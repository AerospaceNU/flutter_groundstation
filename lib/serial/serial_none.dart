import 'package:flutter_libserialport/flutter_libserialport.dart';

abstract class AbstractSerial {
  List<String> serialPorts();
  SerialPortReader reader(String portName);
}

AbstractSerial getAbstractSerial() => throw UnimplementedError("Serial is abstract");
