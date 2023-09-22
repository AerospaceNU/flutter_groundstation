import 'package:flutter/material.dart';
import 'package:show_fps/show_fps.dart';

import 'serial/serial_none.dart' if (dart.library.io) 'serial/serial_desktop.dart' if (dart.library.html) 'serial/serial_web.dart';

import 'widgets/home_pages/desktop_home_page.dart';
import 'widgets/home_pages/testing_home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        //The theme
        //TODO: Lets get this looking as good as we can at some point
        // colorScheme: ColorScheme.fromSeed(
        //     seedColor: const Color(0xffe8202e)),
        colorScheme: const ColorScheme.dark(primary: Color(0xffe8202e), secondary: Color(0xffedbb18)),
        useMaterial3: true,
      ),
      home: const ShowFPS(child: DesktopHomePage(title: 'AeroNU Ground Station')), //Tabs and stuff
//      home: const ShowFPS(child: TestingHomePage(title: 'AeroNU Ground Station')), //Graph and button test
    );
  }
}
