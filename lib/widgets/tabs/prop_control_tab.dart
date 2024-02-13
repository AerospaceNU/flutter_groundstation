import 'package:flutter/material.dart';
import 'package:flutter_groundstation/widgets/text_data.dart'; // Import if needed for TextData

class PropControlTab extends StatelessWidget {
  const PropControlTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const Scaffold(
        body: Padding(
          // adds padding to outer window edges
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                // makes child expand to fill avaliable space
                // TODO: if finer grain control wanted, use Flexible and flex property
                // Expanded for equal dist, Flexible for proportional control
                child: Row(
                  children: [
                    Expanded(child: CustomBox(title: 'SETTINGS', content: BoxContent.none)),
                    SizedBox(width: 8), // this makes space between, an invisble box with a width of 8
                    Expanded(child: CustomBox(title: 'PRIMARY', content: BoxContent.button)),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Expanded(
                child: Row(
                  children: [
                    Expanded(child: CustomBox(title: 'DIAGNOSTIC', content: BoxContent.none)),
                    SizedBox(width: 8),
                    Expanded(child: CustomBox(title: 'GRAPHS', content: BoxContent.none)),
                    SizedBox(width: 8),
                    Expanded(child: CustomBox(title: 'OFFLOAD', content: BoxContent.dropdown)),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Expanded(
                // child: CustomBox(title: 'PROP CONTROL', content: BoxContent.none),
                // Expanded only expands some widgets (ex. Row)
                child: Row(
                  children: [
                    Expanded(child: CustomBox(title: 'PROP CONTROL', content: BoxContent.none)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum BoxContent { none, button, dropdown }

class CustomBox extends StatefulWidget {
  final String title;
  final BoxContent content;

  const CustomBox({Key? key, required this.title, this.content = BoxContent.none}) : super(key: key);

  @override
  _CustomBoxState createState() => _CustomBoxState();
}

class _CustomBoxState extends State<CustomBox> {
  String? selectedValue;
  late List<Widget> contentWidgets;

  @override
  void initState() {
    super.initState();
    contentWidgets = [];

    switch (widget.content) {
      case BoxContent.button:
        contentWidgets.add(ElevatedButton(
          onPressed: () {
            // Handle button press
          },
          child: const Text('Button'),
        ));
        break;
      case BoxContent.dropdown:
        contentWidgets.add(DropdownButton<String>(
          value: selectedValue,
          hint: const Text('Select Option'),
          isExpanded: true,
          items: <String>['Option 1', 'Option 2', 'Option 3'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              selectedValue = newValue;
            });
          },
        ));
        break;
      case BoxContent.none:
      default:
        contentWidgets.add(Text(widget.title)); // Empty container
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueAccent, width:10),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: contentWidgets,
      ),
    );
  }
}