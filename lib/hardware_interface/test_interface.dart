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

    database.updateDatabase("rocket latitude", sin(i / 50)/100 + 42.37);
    database.updateDatabase("rocket longitude", cos(i / 50)/100 -71.06);

    database.updateDatabase("groundstation latitude", 42.361145);
    database.updateDatabase("groundstation longitude", -71.0570803);

    database.updateDatabase("qr_code_lat", 50 * sin(i / 50) + 50);
    database.updateDatabase("qr_code_lon", -71.0899931);
    //database.updateDatabase("qr_code_lat", 42.338807462515526);

  }
}
