import 'dart:typed_data';

/// Serial interface
abstract class AbstractSerial {
  List<String> serialPorts();

  AbstractSerialPortReader reader(String portName);
}

/// Reader wrapper
abstract class AbstractSerialPortReader {
  AbstractSerialPortReader(String portName);

  void setBaudRate(int baudRate);

  void write(Uint8List bytes);

  Stream<Uint8List>? getIncomingStream();

  void close();
}

AbstractSerial getAbstractSerial() => throw UnimplementedError("Serial is abstract");

AbstractSerialPortReader createReader(String port) => throw UnimplementedError("Serial is abstract");
