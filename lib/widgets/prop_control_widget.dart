import 'package:flutter/material.dart';
import 'base_widget.dart';

class PropControlWidget extends StatefulWidget {
  const PropControlWidget({super.key});

  @override 
  State<PropControlWidget> createState() => _PropControlWidgetState();
}

class _PropControlWidgetState extends BaseWidgetState<PropControlWidget> {
  _PropControlWidgetState();
  bool enabled = false;
  String currentState = "UNKNOWN";

  @override 
  Widget build(BuildContext context){
    return Column(children: [
      const Text('Prop System Control'), 
      // Row including the "Set Active Elements" button
      Row(children: [Expanded(child: Column(children: [
                                        Checkbox(value: this.enabled, onChanged: (temp) => {
                                          setState(() {this.enabled = temp!;})  }), 
                                        Text("Override values?")])), 
                    Expanded(child: OutlinedButton(onPressed: this.enabled? ((){}) : null, child: Text('SET ACTIVE ELEMENTS')))
                    ]),
      SizedBox(height: 16.0),
      Container(decoration: BoxDecoration(border: Border.all(color: Colors.white)),
                child: Row(children: [
                            Expanded(child: Text('Current State: $currentState')),
                            Expanded(child: Text('Current Sequence: UNKNOWN')),
                            Expanded(child: Text('Last Abort: UNKNOWN'))]))
    ]);
  }
}
