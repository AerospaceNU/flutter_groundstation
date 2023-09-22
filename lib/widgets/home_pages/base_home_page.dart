import 'dart:async';
import 'package:flutter/cupertino.dart';

import '../../hardware_interface/base_hardware_interface.dart';

import '../base_widget.dart';

/// Base class for home pages for different platforms
/// Contains a list of hardware interfaces, which it manages
abstract class BaseHomePageState<WidgetClass extends StatefulWidget> extends BaseWidgetState<WidgetClass> {
  late Timer guiUpdateLoopTimer;
  var hardwareInterfaceList = <BaseHardwareInterface>[];

  BaseHomePageState() {
    guiUpdateLoopTimer = Timer.periodic(const Duration(milliseconds: 50), runLoopOnce);
  }

  void addHardwareInterface(BaseHardwareInterface hardwareInterface) {
    hardwareInterfaceList.add(hardwareInterface);
  }

  void runLoopOnce(Timer t) {}
}
