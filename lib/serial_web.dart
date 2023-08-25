import 'serial_none.dart';

class WebSerial implements AbstractSerial {
   List<String> serialPorts() { 
    return ['this is a website, silly! thingy is bjork'];
  }
}
AbstractSerial getAbstractSerial() => WebSerial(); //override global fxn to return Web version
