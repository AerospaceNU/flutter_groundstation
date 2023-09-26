import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import '../serial/serial_none.dart' if (dart.library.io) '../serial/serial_desktop.dart' if (dart.library.html) '../serial/serial_web.dart';

import '../binary_parser/binary_parser.dart';

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
    var headerBytes = data.sublist(0, 15);
    var header = ByteData.sublistView(headerBytes);
    var parsedHeader = parseData(header, "<BBBIcccccccc");

    int packetType = parsedHeader[0];
    int softwareVersion = parsedHeader[1];
    int boardSerialNum = parsedHeader[2];
    int timestamp = parsedHeader[3];
    var callsign = parsedHeader.sublist(4, 12).join();

    print(timestamp);
    print(callsign);
    print("  ");
  }
}
