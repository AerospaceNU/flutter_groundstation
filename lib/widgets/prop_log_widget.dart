import 'package:flutter/material.dart';
import 'base_widget.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:intl/intl.dart';
import 'dart:convert';


class PropLogWidget extends StatefulWidget {
  const PropLogWidget({super.key});

  @override 
  State<PropLogWidget> createState() => _PropLogWidgetState('ws://localhost:9002/ws', WebSocketChannel.connect(Uri.parse('ws://localhost:9002/ws')));
}

/*
class PropSockmyWeb {
  final channel = WebSocketChannel.connect(Uri.parse('ws://localhost:9002/ws'),
  );
}
*/

class CommandMyProp {
  final String command;
  final String sumData;

  CommandMyProp(this.command, this.sumData);

  CommandMyProp.fromJson(Map<String, dynamic> json)
      : command = json['command'] as String,
        sumData = json['timestamp'] as String;

  Map<String, dynamic> toJson() => {
        'command': command,
        'timeStamp': sumData,
      };
}


class CommandData extends StatelessWidget {
  const CommandData({super.key, required this.data});

  final String data;

  @override
  Widget build(BuildContext context) {
    dynamic dataJson = jsonDecode(this.data);
    String commandType = dataJson["command"];
    int timeStamp = dataJson["timeStamp"];
    var date = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);


    return Text("${DateFormat('kk:mm:ss').format(date)} $commandType");
  }
}



class _PropLogWidgetState extends BaseWidgetState<PropLogWidget> {
  String url;
  WebSocketChannel channel;
  _PropLogWidgetState(this.url, this.channel) {
    url = 'ws://localhost:9002/ws';
    channel = WebSocketChannel.connect(Uri.parse(url));
  }
  bool enabled = false;
  List<String> logText = [];
  List<Widget> logWidget = [];

  //final channel = WebSocketChannel.connect(Uri.parse(url),);

  //final CommandMap = jsonDecode(jsonString) as Map<String, dynamic>;
  //final command = CommandMyProp.fromJson(CommandMap);  

  @override 
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 57, 6, 6))
        ),
            child: Column(children: [
        StreamBuilder(
          stream: channel.stream,
          builder: (context, snapshot) {
              while (!snapshot.hasData) {
                return Text("${DateFormat('kk:mm:ss').format(DateTime.now())} Trying to connect to $url\n");
              }
              return CommandData(data: snapshot.data);
          }
          ),
      ]
            )
      ),
      );
    }


    // Future<List<Widget>> buildLog () async {
    //   while (!snapshot.hasData) {
    //     logWidget.add(Container(
    //         child: 
    //         Text("${DateFormat('kk:mm:ss').format(DateTime.now())} Trying to connect to $url\n"),
    //         )
    //     );
    //   }
    //   return logWidget;
    // }

}

    /* hypoethetically this is how you would send data
          floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: const Icon(Icons.send),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      _channel.sink.add(_controller.text);
    }
  }
  */


  /* this works but not well 
  child: Column(children: [
        StreamBuilder(
          stream: channel.stream,
          builder: (context, snapshot) {
              while (!snapshot.hasData) {
                return Text("${DateFormat('kk:mm:ss').format(DateTime.now())} Trying to connect to $url\n");
              }
              return CommandData(data: snapshot.data);
          }
          ),
      ]
      */
