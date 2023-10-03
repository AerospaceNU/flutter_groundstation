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

  SerialGroundstationInterface() {
    var ports = serialInterface.serialPorts();
    print("Serial ports ${ports}");

    reader = serialInterface.reader("/dev/ttyACM0");
    reader.port.config.baudRate = 115200;
    reader.stream.listen(callback);
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

//    print(parsedRadioInfo);
//    print(timestamp);
//    print(callsign);
//    print("  ");
  }
}
