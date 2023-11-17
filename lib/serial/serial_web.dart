import 'dart:typed_data';

import 'serial_none.dart';

class WebSerial implements AbstractSerial {
  @override
  List<String> serialPorts() {
    return ['web serial impl'];
  }

  AbstractSerialPortReader reader(String portName) {
    return WebSerialPortReader(portName);
  }
}

/// Reader wrapper
class WebSerialPortReader implements AbstractSerialPortReader {
  WebSerialPortReader(String portName);

  void setBaudRate(int baudRate) {}

  void write(Uint8List bytes) {}

  Stream<Uint8List>? getIncomingStream() {
    return null;
  }

  void close() {}
}

AbstractSerial getAbstractSerial() => WebSerial(); //override global fxn to return Web version

AbstractSerialPortReader createReader(String port) => WebSerialPortReader(port);
