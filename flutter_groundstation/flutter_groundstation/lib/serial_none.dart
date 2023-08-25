abstract class AbstractSerial {
  List<String> serialPorts();
  factory AbstractSerial() => getAbstractSerial();
}

/////////////////////////////////////////////////////////
//foo_locator.dart, contains un-implemented global function
/////////////////////////////////////////////////////////
AbstractSerial getAbstractSerial() => throw UnsupportedError('Cannot create an abstract AbstractSerial!');
 