import 'package:flutter/material.dart';
import 'package:flutter_groundstation/widgets/base_widget.dart';

import '../../hardware_interface/test_interface.dart';
import '../../hardware_interface/serial_groundstation_interface.dart';

import 'base_home_page.dart';

import 'desktop_home_page_menu.dart';
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
    return Column(
      children: [
        const DesktopHomePageMenu(),
        Expanded(
            child: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: const TabBar(
                tabs: [
                  Tab(text: "Test widget"),
                  Tab(text: "Test tab"),
                  Tab(text: "Graphs tab"),
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
              ],
            ),
          ),
        ))
      ],
    );
  }
}
