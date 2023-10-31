import 'package:flutter/material.dart';

import '../qr_code_widget.dart';

class QrCodeTab extends StatelessWidget {
  const QrCodeTab({super.key});

  @override
  Widget build(BuildContext context) {
    // return GridView.count(
    //   primary: false,
    //   padding: const EdgeInsets.all(20),
    //   crossAxisSpacing: 10,
    //   mainAxisSpacing: 10,
    //   crossAxisCount: 3,
    //   children: <Widget>[
    //const QRCodeWidget(),
    return const DropDown();
    //],
    //);
  }
}
