import 'dart:async';

import 'base_hardware_interface.dart';

///Generates random data for testing UI elements
class TestHardwareInterface extends BaseHardwareInterface {
  int i = 0;

  TestHardwareInterface();

  @override
  void runLoopOnce(Timer t) {
    database.updateDatabase("test", i++);
  }
}
