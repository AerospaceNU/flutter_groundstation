import 'package:flutter/material.dart';

import 'package:flutter_groundstation/widgets/tabs/home_tab.dart';
import 'package:flutter_groundstation/widgets/tabs/serial_test_tab.dart';

import 'base_home_page.dart';

import '../tabs/test_tab.dart';
import '../tabs/graphs_tab.dart';
import '../desktop_home_page_menu.dart';

import '../../hardware_interface/test_interface.dart';
import '../../hardware_interface/serial_groundstation_interface.dart';
import '../../hardware_interface/flight_simulation.dart';


class DesktopHomePage extends StatefulWidget {
  final String title;

  const DesktopHomePage({super.key, required this.title});

  @override
  State<DesktopHomePage> createState() => _DesktopHomePageState();
}

///Desktop home page
///Will have a bunch of tabs to show different data streams from the rocket
class _DesktopHomePageState extends BaseHomePageState<DesktopHomePage> {
  _DesktopHomePageState() {
    addHardwareInterface(TestHardwareInterface());
    addHardwareInterface(SerialGroundstationInterface());
    addHardwareInterface(FlightSimulation());
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const DesktopHomePageMenu(),
      Expanded(
          child: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: const TabBar(
              tabs: [
                Tab(text: "Primary"),
                Tab(text: "Test tab"),
                Tab(text: "Graphs"),
                Tab(text: "serial"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              const HomeTab(),
              const TestTab(),
              const GraphTab(),
              SerialTab(),
            ],
          ),
        ),
      ))
    ]);
  }
}
