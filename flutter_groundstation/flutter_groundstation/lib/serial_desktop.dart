import 'package:flutter_libserialport/flutter_libserialport.dart';
import "serial_none.dart";

class DesktopSerial implements AbstractSerial {
  List<String> serialPorts() {
    return SerialPort.availablePorts;
  }
}

AbstractSerial getAbstractSerial() =>
    DesktopSerial(); //override global fxn to return desktop version
