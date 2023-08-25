import 'package:flutter_libserialport/flutter_libserialport.dart';
import "serial_none.dart";

/////////////////////////////////////////////////////////
// foo_io.dart, implements the abstract class, and overrides the global fxn
/////////////////////////////////////////////////////////
class AbstractSerialIo implements AbstractSerial {
  List<String> serialPorts() {
    return SerialPort.availablePorts;
  }
}

AbstractSerial getAbstractSerial() =>
    AbstractSerialIo(); //override global fxn to return Io
