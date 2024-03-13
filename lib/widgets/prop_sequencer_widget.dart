import 'package:flutter/material.dart';

class PropSequencerWidget extends StatelessWidget {
  const PropSequencerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Text("Sequencer"),
      Checkbox(value: false, onChanged: (temp) => false),
      DropdownButton<String>(
          value: "Bruh1",
          hint: const Text('Sequences'),
          isExpanded: true,
          items: <String>['TEST_SEQUENCE_1', 'TEST_SEQUENCE_2', 'TEST_SEQUENCE_3'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: null,
          // onChanged: (newValue) {
          //   setState(() {
              
          //   });
          // },
        )

    ],);
  }

  // @override
  // State<PyroDataWidget> createState() => _PyroWidgetState();
}

// class _PyroWidgetState extends BaseWidgetState<PyroDataWidget> {
//   _PyroWidgetState();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16.0),
//       height: 600,
//       child: Column(children: <Widget>[
//         Container(
//           height: 75,
//           decoration: BoxDecoration(border: Border.all(color: Colors.black)),
//           child: const Center(
//             child: Text('Pyro Output Data'),
//           ),
//         ),
//         SingleChildScrollView(
//           child: Container(
//             height: 400,
//             decoration: BoxDecoration(color: Colors.black, border: Border.all(color: Colors.black)),
//             child: const Center(
//               child: Text(
//                 '1',
//                 style: TextStyle(color: Colors.white),
//                 textAlign: TextAlign.right,
//               ),
//             ),
//           ),
//         ),
//       ]),
//     );
//   }
// }
