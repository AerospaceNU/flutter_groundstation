abstract class AbstractSerial {
  List<String> serialPorts();
  factory AbstractSerial() => getAbstractSerial();
}

AbstractSerial getAbstractSerial() => throw UnsupportedError('Cannot create an abstract AbstractSerial!');
 