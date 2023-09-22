import 'package:flutter/material.dart';
import 'package:flutter_groundstation/widgets/base_widget.dart';

import '../../hardware_interface/test_interface.dart';

import 'base_home_page.dart';

import '../test_widget.dart';
import '../graph_widget.dart';

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
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text(widget.title)),
      body: const Center(
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TestWidget(),
            GraphWidget(),
          ],
        )),
      ),
      floatingActionButton: FloatingActionButton(onPressed: onButtonPress, tooltip: 'Increment', child: const Icon(Icons.add)),
    );
  }
}
