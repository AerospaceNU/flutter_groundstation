abstract class AbstractSerial {
  List<String> serialPorts();
}

AbstractSerial getAbstractSerial() => throw UnimplementedError("Serial is abstract");
