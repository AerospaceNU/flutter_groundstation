import 'serial_none.dart';

class WebSerial implements AbstractSerial {
  @override
  List<String> serialPorts() {
    return ['web serial impl'];
  }

  @override
  SerialPortReader reader(String portName) {
    // TODO: implement reader
    throw UnimplementedError();
  }
}

AbstractSerial getAbstractSerial() => WebSerial(); //override global fxn to return Web version
