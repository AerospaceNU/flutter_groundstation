import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DesktopHomePageMenu extends StatelessWidget {
  const DesktopHomePageMenu({super.key});

  @override
  Widget build(BuildContext context) {
    var fileMenu = {"a": () {}, "c": () {}};
    var moduleMenu = {"a": () {}, "b": () {}};
    var fullMenu = {"file": fileMenu, "modules": moduleMenu};

    var menuWidgets = <Widget>[];

    for (var menu in fullMenu.keys) {
      var subMenuWidgets = <Widget>[];
      var subMenuData = fullMenu[menu];

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
