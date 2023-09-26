import 'package:flutter/material.dart';
import 'package:flutter_groundstation/widgets/base_widget.dart';
import 'package:flutter_groundstation/widgets/tabs/map_tab.dart';

import '../../hardware_interface/test_interface.dart';
import '../../hardware_interface/serial_groundstation_interface.dart';

import 'base_home_page.dart';

import '../tabs/test_tab.dart';
import '../tabs/graphs_tab.dart';

import '../test_widget.dart';

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
  }

  void onButtonPress() {
    var counterVal = BaseWidgetState.database.getValue("counter", 0);
    BaseWidgetState.database.updateDatabase("counter", counterVal + 1);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(text: "Test widget"),
              Tab(text: "Test tab"),
              Tab(text: "Graphs tab"),
              Tab(text: "Map Tab"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Scaffold(
              body: const Center(child: TestWidget()),
              floatingActionButton: FloatingActionButton(onPressed: onButtonPress, tooltip: 'Increment', child: const Icon(Icons.add)),
            ),
            const TestTab(),
            const GraphTab(),
            const MapTab(),
          ],
        ),
      ),
    );
  }
}
