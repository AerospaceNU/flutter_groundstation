import 'dart:async';
import 'dart:math';

import 'base_hardware_interface.dart';

///Generates random data for testing UI elements
class TestHardwareInterface extends BaseHardwareInterface {
  int i = 0;
  var random = Random();

  TestHardwareInterface();

  @override
  void runLoopOnce(Timer t) {
    database.updateDatabase("test", i++);
    database.updateDatabase("test_1", sin(i / 50));
    database.updateDatabase("test_2", sin(i / 5) + 3);
    database.updateDatabase("test_3", sin(i / 50) + 6);

    database.updateDatabase("random_1", random.nextDouble());
  }
}
