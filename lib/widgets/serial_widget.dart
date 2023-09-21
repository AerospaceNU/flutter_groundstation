import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import '../serial/serial_desktop.dart';
import 'base_widget.dart';

class SerialWidget extends StatefulWidget {
  const SerialWidget({super.key});

  @override
  State<SerialWidget> createState() => _SerialWidgetState();
}

class _SerialWidgetState extends BaseWidgetState<SerialWidget> {
  @override
  Widget build(BuildContext context) {
//    print("Rebuilding");

    List<String> serialPorts = SerialPort.availablePorts;

    Stream<String> stream =
        getAbstractSerial().reader(serialPorts[0]).stream.map((data) {
          return String.fromCharCodes(data).codeUnits.map((x) => x.toRadixString(2).padLeft(8, '0')).join();
        });

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // Serial stream
        StreamBuilder<String>(
          stream: stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data!);
            } else {
              return const Text("No data");
            }
          },
        )
      ],
    );
  }
}
