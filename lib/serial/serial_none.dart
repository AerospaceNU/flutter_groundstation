abstract class AbstractSerial {
  List<String> serialPorts();
  SerialPortReader reader(String portName);
}

AbstractSerial getAbstractSerial() => throw UnimplementedError("Serial is abstract");
