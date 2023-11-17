import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_groundstation/widgets/base_widget.dart';
import '../../constants.dart';

class DesktopHomePageMenu extends StatefulWidget {
  const DesktopHomePageMenu({super.key});

  @override
  State<DesktopHomePageMenu> createState() => _DesktopHomePageMenuState();
}

class _DesktopHomePageMenuState extends BaseWidgetState<DesktopHomePageMenu> {
  void onModuleMenu(String moduleName) {
    callbackHandler.requestCallback(Constants.toggleModuleEnable, moduleName);
    callbackHandler.runQueuedCallbacks();
  }

  @override
  Widget build(BuildContext context) {
    var moduleInfo = getDatabaseValue(Constants.moduleInfo, {});

    var fileMenu = {"a": () {}, "c": () {}};

    var moduleMenu = {};
    for (var moduleName in moduleInfo.keys) {
      bool enabled = moduleInfo[moduleName];

      if (enabled) {
        moduleMenu["Disable $moduleName"] = () {onModuleMenu(moduleName);};
      } else {
        moduleMenu["Enable $moduleName"] = () {onModuleMenu(moduleName);};
      }
    }

    var menuOptions = {"File": fileMenu, "Modules": moduleMenu};

    var menuWidgets = <Widget>[];

    for (var menu in menuOptions.keys) {
      var subMenuWidgets = <Widget>[];
      var subMenuData = menuOptions[menu];

      for (var subMenu in subMenuData!.keys) {
        var callback = subMenuData[subMenu];

        var subMenuWidget = MenuItemButton(
          onPressed: callback,
          child: MenuAcceleratorLabel(subMenu),
        );

        subMenuWidgets.add(subMenuWidget);
      }

      var menuWidget = SubmenuButton(
        menuChildren: subMenuWidgets,
        child: MenuAcceleratorLabel(menu),
      );

      menuWidgets.add(menuWidget);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          child: MenuBar(
            children: menuWidgets,
          ),
        ),
      ],
    );
  }
}
