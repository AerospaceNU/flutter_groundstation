import 'package:flutter/material.dart';

import 'base_widget.dart';

class TestWidget extends StatefulWidget {
  const TestWidget({super.key});

  @override
  State<TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends BaseWidgetState<TestWidget> {
  @override
  Widget build(BuildContext context) {
//    print("Rebuilding");

    var textWidget = const Text('Test text');
    var wid_2 = const Text('You have pushed the button this many times:');
    var wid_3 = Text('${getDatabaseValue("counter", 0)}', style: Theme.of(context).textTheme.headlineMedium);
    var wid_4 = TextButton(onPressed: () => {}, child: const Text("hello"));

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[textWidget, wid_2, wid_3, wid_4],
    );
  }
}
