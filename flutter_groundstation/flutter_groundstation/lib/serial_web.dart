import 'serial_none.dart';

class AbstractSerialWeb implements AbstractSerial {
   List<String> serialPorts() { 
    return ['this is a website, silly! thingy is bjork'];
  }
}
AbstractSerial getAbstractSerial() => AbstractSerialWeb(); //override global fxn to return Web
