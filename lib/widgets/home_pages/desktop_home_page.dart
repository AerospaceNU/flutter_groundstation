import 'package:flutter/material.dart';
import 'package:flutter_groundstation/widgets/base_widget.dart';
import 'package:flutter_groundstation/widgets/graph_widget.dart';
import 'package:flutter_groundstation/widgets/tabs/home_tab.dart';
import 'package:flutter_groundstation/widgets/text_data.dart';
import 'package:flutter_resizable_container/flutter_resizable_container.dart';

import '../../hardware_interface/test_interface.dart';

import 'base_home_page.dart';

import '../tabs/test_tab.dart';
import '../tabs/graphs_tab.dart';

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
              body: const Center(child: HomeTab(
                topBar: HomeTopBar(widgets: [
                  TextData(dataKey: "test", wrapWords: false,),
                  TextData(dataKey: "random_1", wrapWords: false, decimals: 6,),
                  GraphWidget(),
                ], border: Colors.black38),
                leftBar: HomeLeftBar(widgets: [
                  GraphWidget(),
                  GraphWidget(),
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