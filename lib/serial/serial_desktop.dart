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
      } ();  // NOTE: '()' may be an error
      return devices.map((e) => e.deviceName).toList();

    }
    return SerialPort.availablePorts;
  }
}

AbstractSerial getAbstractSerial() =>
    DesktopSerial(); //override global fxn to return desktop version
