import 'package:flutter/material.dart';
import 'base_widget.dart';


class PropSequencerWidget extends StatefulWidget {
  const PropSequencerWidget({super.key});

  @override
  State<PropSequencerWidget> createState() => _PropWidgetState();
}

class _PropWidgetState extends BaseWidgetState<PropSequencerWidget> {
  String selectedValue = "TEST_SEQUENCE_1";
  bool enabled = false;
  _PropWidgetState();

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Text("Sequencer"),
      Checkbox(value: this.enabled, onChanged: (temp) => {
            setState(() {
              this.enabled = temp!;
            })
          }),
      DropdownButton<String>(
          value: this.selectedValue,
          hint: const Text('Sequences'),
          isExpanded: true,
          items: <String>['TEST_SEQUENCE_1', 'TEST_SEQUENCE_2', 'TEST_SEQUENCE_3'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          // onChanged: null,
          onChanged: this.enabled ? 
          (String? newValue) { // if enabled, actually working funct
            setState(() {
              this.selectedValue = newValue!;
            });
          } 
          : null, // if not enabled, setting onChanged to null disables it
        )

    ],);
  }
}