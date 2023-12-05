import 'dart:async';
import 'package:flutter/cupertino.dart';

import '../../hardware_interface/base_hardware_interface.dart';

import '../base_widget.dart';
import '../../constants.dart';

/// Base class for home pages for different platforms
/// Contains a list of hardware interfaces, which it manages
abstract class BaseHomePageState<WidgetClass extends StatefulWidget> extends BaseWidgetState<WidgetClass> {
  late Timer guiUpdateLoopTimer;
  var hardwareInterfaceList = <BaseHardwareInterface>[];

  BaseHomePageState() {
    guiUpdateLoopTimer = Timer.periodic(const Duration(milliseconds: 50), runLoopOnce);

    callbackHandler.registerCallback(Constants.toggleModuleEnable, moduleToggleCallback);
  }

  void moduleToggleCallback(String moduleData) {
    for (var module in hardwareInterfaceList) {
      if (module.runtimeType.toString() == moduleData) {
        module.toggleEnabled();
      }
    }

    updateModuleInfo();
  }

  void addHardwareInterface(BaseHardwareInterface hardwareInterface) {
    hardwareInterfaceList.add(hardwareInterface);
    updateModuleInfo();
  }

  void updateModuleInfo() {
    var moduleInfo = {};
    for (var module in hardwareInterfaceList) {
      moduleInfo[module.runtimeType.toString()] = module.isEnabled();
    }
    BaseWidgetState.database.updateDatabase(Constants.moduleInfo, moduleInfo);
  }

  void runLoopOnce(Timer t) {}
}
