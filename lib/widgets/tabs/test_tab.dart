import 'package:flutter/material.dart';

import '../test_widget.dart';
import '../graph_widget.dart';

class TestTab extends StatelessWidget {
  const TestTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 2,
      children: <Widget>[
        const TestWidget(),
        const GraphWidget(title: "Test Graph", keyList: ["test_1", "test_2", "random_1"]),
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.teal[300],
          child: const Text('USB C Sucks'),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.teal[400],
          child: const Text('aaaaaaaaaaaa'),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.teal[500],
          child: const Text('Test Box 5'),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.teal[600],
          child: const Text('You know... they literally let you put anything here...'),
        ),
      ],
    );
  }
}
