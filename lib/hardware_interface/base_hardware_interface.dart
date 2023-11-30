import 'dart:async';

import '../database.dart';

///Extend this class to add custom (non-front-end) functionality to the GUI
class BaseHardwareInterface {
  var database = Database();
  late Timer guiUpdateLoopTimer;
  var enabled = false;

  BaseHardwareInterface() {
    guiUpdateLoopTimer = Timer.periodic(const Duration(milliseconds: 50), runLoopOnce);
  }

  bool isEnabled() {
    return enabled;
  }

  void setEnabled(bool shouldBeEnabled) {
    enabled = shouldBeEnabled;
  }

  void toggleEnabled() {
    enabled = !enabled;
  }

  void runLoopOnce(Timer t) {
    if (enabled) {
      runWhileEnabled();
    }
  }

  void runWhileEnabled() {}
}
