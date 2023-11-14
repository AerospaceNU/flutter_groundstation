import 'dart:async';

import '../database.dart';

///Extend this class to add custom (non-front-end) functionality to the GUI
class BaseHardwareInterface {
  var database = Database();
  late Timer guiUpdateLoopTimer;
  var enabled = true;

  BaseHardwareInterface() {
    guiUpdateLoopTimer = Timer.periodic(const Duration(milliseconds: 50), runLoopOnce);
  }

  void toggleEnabled(){
    enabled = !enabled;
  }

  void runLoopOnce(Timer t) {}
}
