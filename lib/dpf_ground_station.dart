import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:show_fps/show_fps.dart';

import 'widgets/home_pages/desktop_home_page.dart';

// This widget is the root of your application.
class DpfGroundStation extends StatefulWidget {
  const DpfGroundStation({super.key});

  @override
  State<DpfGroundStation> createState() => _DpfGroundStationState();

  /// Allows ThemeModeSwitch to get the state of the application
  static _DpfGroundStationState _of(BuildContext context) =>
      context.findAncestorStateOfType<_DpfGroundStationState>()!;
}

/// State of the application
class _DpfGroundStationState extends State<DpfGroundStation> {
  ThemeMode _themeMode = ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    //TODO: Load a different home page on different platforms
    var home = const DesktopHomePage(title: 'AeroNU Ground Station');
    // var home = const TestingHomePage(title: 'testing');

    StatefulWidget homePage;
    if (kDebugMode) {
      //Show an FPS counter in debug mode
      homePage = ShowFPS(child: home);
    } else {
      homePage = home;
    }

    return MaterialApp(
      title: 'Flutter Groundstation',
      theme: ThemeData(
        //The theme
        //TODO: Lets get this looking as good as we can at some point
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xffe8202e)),
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
          colorScheme: const ColorScheme.dark(primary: Color(0xffe8202e), secondary: Color(0xffedbb18)),
          brightness: Brightness.dark,
          useMaterial3: true
      ),
      themeMode: _themeMode,
      home: homePage,
    );
  }

  ///  Allows caller to change the theme of the application.
  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }
}

/// A switch that allows the user to change the theme of the application
/// between light mode and dark mode.
class ThemeModeSwitch extends StatefulWidget {
  const ThemeModeSwitch({super.key});

  @override
  State<ThemeModeSwitch> createState() => _ThemeModeSwitchState();
}

class _ThemeModeSwitchState extends State<ThemeModeSwitch> {
  @override
  Widget build(BuildContext context) {
    _DpfGroundStationState appState = DpfGroundStation._of(context);
    return Switch(
        value: appState._themeMode == ThemeMode.dark,
        onChanged: (bool value) {
          setState(() {
            appState.changeTheme(
                value ? ThemeMode.dark : ThemeMode.light);
          });
        });
  }
}
