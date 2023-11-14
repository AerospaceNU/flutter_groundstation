import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DesktopHomePageMenu extends StatelessWidget {
  late final menuOptions;
  
  DesktopHomePageMenu({required this.menuOptions, super.key});

  @override
  Widget build(BuildContext context) {
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
