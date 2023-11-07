import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DesktopHomePageMenu extends StatelessWidget {
  const DesktopHomePageMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
      MenuBar(
        children: <Widget>[
          SubmenuButton(
            menuChildren: <Widget>[
              MenuItemButton(
                onPressed: () {
                  showAboutDialog(
                    context: context,
                    applicationName: 'MenuBar Sample',
                    applicationVersion: '1.0.0',
                  );
                },
                child: const MenuAcceleratorLabel('&About'),
              ),
              MenuItemButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Saved!'),
                    ),
                  );
                },
                child: const MenuAcceleratorLabel('&Save'),
              ),
              MenuItemButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Quit!'),
                    ),
                  );
                },
                child: const MenuAcceleratorLabel('&Quit'),
              ),
            ],
            child: const MenuAcceleratorLabel('&File'),
          ),
          SubmenuButton(
            menuChildren: <Widget>[
              MenuItemButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Magnify!'),
                    ),
                  );
                },
                child: const MenuAcceleratorLabel('&Magnify'),
              ),
              MenuItemButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Minify!'),
                    ),
                  );
                },
                child: const MenuAcceleratorLabel('Mi&nify'),
              ),
            ],
            child: const MenuAcceleratorLabel('&View'),
          ),
        ],
      )
    ]);
  }
}
