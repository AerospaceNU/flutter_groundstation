import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import './base_widget.dart';
import '../constants.dart';

// https://pub.dev/packages/qr_flutter
// https://medium.com/podiihq/generating-qr-code-in-a-flutter-app-50de15e39830

class QRCodeImageWidget extends StatelessWidget {
  const QRCodeImageWidget(this.type, this.lat, this.lon, {super.key});

  final String type;
  final double lat;
  final double lon;

  String getData() {
    if (type == "Google") {
      return "https://www.google.com/maps/search/?api=1&query=$lat%2C$lon";
    } else if (type == "Apple") {
      return "https://maps.apple.com/?ll=$lat,$lon&q=Dropped%20Pin";
    } else if (type == "Geo") {
      return "geo:$lat,$lon";
    } else {
      return "$lat,$lon";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Flexible(
          child: QrImageView(
        data: getData(),
      )),
      Text(getData())
    ]);
  }
}

class QRCodeWidget extends StatefulWidget {
  const QRCodeWidget({super.key});

  @override
  _QRCodeWidgetState createState() => _QRCodeWidgetState();
}

class _QRCodeWidgetState extends BaseWidgetState<QRCodeWidget> {
  String mapType = 'Google';
  String boardType = 'FCB';
  bool frozen = false;
  double curLat = 0.0;
  double curLon = 0.0;

  String printFrozen(bool yes) {
    return yes ? "frozen" : "not frozen";
  }

  double getLatNotFrozen() {
    if (!frozen) {
      curLat = getDatabaseValue(Constants.latitude, 0.0);
    }
    return curLat;
  }

  double getLonNotFrozen() {
    if (!frozen) {
      curLon = getDatabaseValue(Constants.longitude, 0.0);
    }
    return curLon;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Location QR Code Generator'),
        ),
        body: Center(
          child: Container(
              child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                DropdownButton<String>(
                  value: mapType,
                  onChanged: (String? newValue) {
                    setState(() {
                      mapType = newValue!;
                    });
                  },
                  items: <String>['Google', 'Apple', 'Geo', 'Raw'].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const Spacer(),
                DropdownButton<String>(
                  value: boardType,
                  onChanged: (String? newValue) {
                    setState(() {
                      boardType = newValue!;
                    });
                  },
                  items: <String>['FCB', 'EggFinder'].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const Spacer(),
                Text(printFrozen(frozen)),
                Checkbox(
                  value: frozen,
                  onChanged: (bool? value) {
                    setState(() {
                      frozen = value!;
                    });
                  },
                ),
                const Spacer(),
              ],
            ),
            Flexible(
                child: QRCodeImageWidget(
              mapType,
              getLatNotFrozen(),
              getLonNotFrozen(),
            )),
          ])),
        ));
  }
}
