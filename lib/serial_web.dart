import 'serial_none.dart';

class WebSerial implements AbstractSerial {
   List<String> serialPorts() { 
    return ['web serial impl'];
  }
}

AbstractSerial getAbstractSerial() => WebSerial(); //override global fxn to return Web version
