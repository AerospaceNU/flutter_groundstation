import 'dart:async';
import 'dart:math';

import 'base_hardware_interface.dart';

///Generates random data for testing UI elements
class TestHardwareInterface extends BaseHardwareInterface {
  int i = 0;
  var random = Random();

  TestHardwareInterface();
  int max_pyros = 7;

  @override
  void runLoopOnce(Timer t) {
    database.updateDatabase("test", i++);
    database.updateDatabase("test_1", sin(i / 50));
    database.updateDatabase("test_2", sin(i / 5) + 3);
    database.updateDatabase("test_3", sin(i / 50) + 6);

    database.updateDatabase("random_1", random.nextDouble());


    List<bool> wid_3 = List<bool>.filled(max_pyros, false);
    for (int i = 0; i < max_pyros; i++) {
      wid_3[i] = random.nextBool();
    }
    database.updateDatabase("pyro-status", wid_3);
  }
}
