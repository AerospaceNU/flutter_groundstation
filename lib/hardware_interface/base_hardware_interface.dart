import 'dart:async';

import '../database.dart';

///Extend this class to add custom (non-front-end) functionality to the GUI
class BaseHardwareInterface {
  var database = Database();
  late Timer guiUpdateLoopTimer;

  BaseHardwareInterface() {
    guiUpdateLoopTimer = Timer.periodic(const Duration(milliseconds: 50), runLoopOnce);
  }

  void runLoopOnce(Timer t) {}
}
