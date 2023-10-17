import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import '../serial/serial_none.dart' if (dart.library.io) '../serial/serial_desktop.dart' if (dart.library.html) '../serial/serial_web.dart';

import '../binary_parser/binary_parser.dart';
import 'fcb_message_definitions.dart';

import '../constants.dart';
import 'base_hardware_interface.dart';

///Reads data from serial port, and updates database
class SerialGroundstationInterface extends BaseHardwareInterface {
  var serialInterface = getAbstractSerial();
  late SerialPort port;
  late SerialPortReader reader;
  var desiredPort = "/dev/ttyACM0";
  var portOpen = false;

  var lastDataTime = 0;
  var nextCheckTime = 0;

  SerialGroundstationInterface();

  @override
  void runLoopOnce(Timer t) {
    var currentTime = DateTime.timestamp().millisecondsSinceEpoch;

    if (currentTime > nextCheckTime && !portOpen) {
      var ports = serialInterface.serialPorts();
      if (ports.contains(desiredPort)) {
        try {
          reader = serialInterface.reader(desiredPort);
          reader.port.config.baudRate = 115200;
          reader.stream.listen(callback);
          print("Opened port $desiredPort");
          portOpen = true;
          lastDataTime = currentTime + 5000;
        } catch (e) {
          print(e);
        }
      } else {
        print("Unable to open serial port $desiredPort, options are $ports");
      }

      nextCheckTime = currentTime + 1000;
    }

    if (portOpen && currentTime - lastDataTime > 2200) {
      reader.port.close();
      reader.close();
      portOpen = false;
      print("Closed port");
    }
  }

  void callback(Uint8List data) {
    if (data.length < 132) {
      print(data.length);
      return;
    }

    var headerBytes = data.sublist(0, 15);
    var radioInfoBytes = data.sublist(data.length - 4);
    var packetBytes = data.sublist(15, data.length - 4);

    var header = ByteData.sublistView(headerBytes);
    var radioInfo = ByteData.sublistView(radioInfoBytes);
    var packet = ByteData.sublistView(packetBytes);

    var parsedHeader = parseData(header, "<BBBIcccccccc");
    var parsedRadioInfo = parseData(radioInfo, "<Bb?B");

    int packetType = parsedHeader[0];
    int softwareVersion = parsedHeader[1];
    int boardSerialNum = parsedHeader[2];
    int timestamp = parsedHeader[3];
    var callsign = parsedHeader.sublist(4, 12).join();

    int radioId = parsedRadioInfo[0];
    int rssi = parsedRadioInfo[1];
    bool crc = parsedRadioInfo[2];
    int lqi = parsedRadioInfo[3];

    //TODO: More constants
    var packetDict = {
      "packet_type": packetType,
      Constants.softwareVersion: softwareVersion,
      Constants.serialNumber: boardSerialNum,
      Constants.timestampMs: timestamp,
      Constants.callsign: callsign,
      "radio_id": radioId,
      "rssi": rssi,
      "crc": crc,
      "lqi": lqi,
    };

    var messageDict = parseMessage(packetType, packet);

    packetDict.addAll(messageDict);

//    print(packetDict);
//    print(messageDict);

    database.bulkUpdateDatabase(packetDict);

    lastDataTime = DateTime.timestamp().millisecondsSinceEpoch;

//    print(parsedRadioInfo);
//    print(timestamp);
//    print(callsign);
//    print("  ");
  }
}
