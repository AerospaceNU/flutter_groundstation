import 'dart:typed_data';

abstract class AbstractSerial {
  List<String> serialPorts();
  AbstractSerialPortReader reader(String portName);
}

abstract class AbstractSerialPortReader {
  AbstractSerialPortReader(String portName, int baudRate, whatever);

  Stream<Uint8List> getIncomingStream();
}

AbstractSerial getAbstractSerial() => throw UnimplementedError("Serial is abstract");
AbstractSerialPortReader createReader(String port) => throw UnimplementedError("Serial is abstract");
