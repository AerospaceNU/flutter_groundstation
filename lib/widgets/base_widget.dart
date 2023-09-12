import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database.dart';

class BaseWidget extends StatefulWidget {
  const BaseWidget({super.key});

  @override
  State<BaseWidget> createState() => _BaseWidgetState();
}

class _BaseWidgetState extends State<BaseWidget> {
//  _BaseWidgetState() {}

  Widget onDatabaseUpdate(BuildContext buildContext, Database database, Widget? widget) {
    print("HI");
//    setState(() {});
    return const Text("abcd");
  }

  @override
  Widget build(BuildContext context) {
    print("Ayy");

    var textWidget = const Text('Test text');
    var wid_2 = const Text('You have pushed the button this many times:');
//    var wid_3 = Text('0', style: Theme.of(context).textTheme.headlineMedium);

    var wid_3 = Consumer<Database>(builder: (context, database, child) => Text('${database.getValue("counter", 0)}', style: Theme.of(context).textTheme.headlineMedium));

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[textWidget, wid_2, wid_3],
    );
  }
}
