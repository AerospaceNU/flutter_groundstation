import 'package:flutter/material.dart';
import 'base_widget.dart';

class StreamWidget extends StatefulWidget {
  const StreamWidget({super.key});

  @override
  State<StreamWidget> createState() => _StreamWidgetState();
}

class _StreamWidgetState extends BaseWidgetState<StreamWidget> {
  @override
  Widget build(BuildContext context) {
    // var textWidget = const Text('Stream widget time');
    // var wid_2 = const Text('You have pushed the button this many times:');
    // var wid_3 = Text('${getDatabaseValue("counter", 0)}',
    //     style: Theme.of(context).textTheme.headlineMedium);
    // var wid_4 = TextButton(onPressed: () => {}, child: const Text("hello"));

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("It's streaming time"),
        StreamBuilder<dynamic>(
          stream: getStream(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              // Display the data from the stream
              return Text('Number: ${snapshot.data}');
            } else if (snapshot.hasError) {
              // Handle error case
              return Text('Error: ${snapshot.error}');
            } else {
              // Handle loading or initial state
              return CircularProgressIndicator();
            }
          },
        )
      ],
    );
  }
}
