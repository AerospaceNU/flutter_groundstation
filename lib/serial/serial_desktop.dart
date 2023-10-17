import 'dart:typed_data';

import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:usb_serial/usb_serial.dart';

import 'serial_none.dart';
import 'dart:io' show Platform;

class DesktopSerial implements AbstractSerial {
  @override
  List<String> serialPorts() {
    if (Platform.isAndroid) {
      List<UsbDevice> devices = [];

      () async {
        devices = await UsbSerial.listDevices();
      }(); // NOTE: '()' may be an error
      return devices.map((e) => e.deviceName).toList();
    }
    return SerialPort.availablePorts;
  }

  @override
  SerialPortReader reader(String portName) {
    SerialPort port = SerialPort(portName);
    port.openReadWrite();
    SerialPortReader reader = SerialPortReader(port);
    return reader;
  }
}

class DesktopSerialReader implements AbstractSerialPortReader {
  late SerialPortReader wrapped;

  Stream<Uint8List> getIncomingStream() {
    return wrapped.stream;
  }
}

AbstractSerial getAbstractSerial() => DesktopSerial(); //override global fxn to return desktop version

AbstractSerialPortReader createReader(String port) => DesktopSerialReader();