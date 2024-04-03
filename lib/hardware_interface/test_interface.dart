import 'dart:math';

import 'package:flutter_groundstation/data_stream.dart';

import 'base_hardware_interface.dart';

import '../constants.dart';

///Generates random data for testing UI elements
class TestHardwareInterface extends BaseHardwareInterface {
  int i = 0;
  var random = Random();

  TestHardwareInterface();
  int max_pyros = 7;

  @override
  void runWhileEnabled() {
    //Make sim packet
    var packet = <String, dynamic>{};
    packet["test"] = i++;
    packet["test_1"] = sin(i / 50);
    packet["test_2"] = sin(i / 5) + 3;
    packet["test_3"] = sin(i / 50) + 6;
    packet["random_1"] = random.nextDouble();
    packet[Constants.latitude] = sin(i / 50) / 100 + 42.37;
    packet[Constants.longitude] = cos(i / 50) / 100 - 71.06;
    packet[Constants.groundStationLatitude] = 42.361145;
    packet[Constants.groundStationLongitude] = -71.0570803;

    List<bool> testPyroFireStatus = List<bool>.filled(max_pyros, false);
    for (int i = 0; i < max_pyros; i++) {
      testPyroFireStatus[i] = random.nextBool();
    }
    packet[Constants.pyroFireStatus] = testPyroFireStatus;

    List<bool> testPyroContinuity = List<bool>.filled(max_pyros, false);
    for (int i = 0; i < max_pyros; i++) {
      testPyroContinuity[i] = random.nextBool();
    }
    packet[Constants.pyroContinuity] = testPyroContinuity;

    DataStream.streamcontroller.add(packet);
  }
}
