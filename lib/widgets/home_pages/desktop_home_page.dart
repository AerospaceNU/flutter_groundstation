import 'package:flutter/material.dart';

import 'package:flutter_groundstation/widgets/base_widget.dart';
import 'package:flutter_groundstation/widgets/battery_indicator.dart';
import 'package:flutter_groundstation/widgets/graph_widget.dart';
import 'package:flutter_groundstation/widgets/tabs/home_tab.dart';
import 'package:flutter_groundstation/widgets/text_data.dart';

import 'base_home_page.dart';

import '../tabs/test_tab.dart';
import '../tabs/graphs_tab.dart';

import '../../hardware_interface/test_interface.dart';
import '../../hardware_interface/serial_groundstation_interface.dart';

import '/constants.dart';

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
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
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
              body: Center(child: HomeTab(
                topBar: HomeTopBar(widgets: [
                  const TextData(dataKey: "test", wrapWords: false,),
                  const TextData(dataKey: "random_1", wrapWords: false, decimals: 6,),
                  BatteryIndicator(label: "random", dataKey: "random_1", min: 0, max: 1, width: 20, displayData: true,)
                ], border: Colors.black38),
                leftBar: const HomeLeftBar(widgets: [
                  GraphWidget(title: "Altitude", keyList: [Constants.altitude, Constants.gpsAltitude]),
                  TextData(dataKey: "random_2", wrapWords: false, decimals: 6,)
                ], border: Colors.black38),
              )),
              floatingActionButton: FloatingActionButton(onPressed: onButtonPress, tooltip: 'Increment', child: const Icon(Icons.add)),
            ),
            const TestTab(),
            const GraphTab(),
          ],
        ),
      ),
    );
  }
}
