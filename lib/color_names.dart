import 'package:flutter/material.dart';

//Aparently there's literally no library that does this
var colorNames = {
  "red": Colors.red,
  "green": Colors.green,
  "blue": Colors.blue,
  "magenta": Colors.purple,
};

Color? colorFromName(String colorName) {
  if (colorNames.keys.contains(colorName)) {
    return colorNames[colorName]?.withAlpha(255);
  } else {
    print("Unknown color $colorName");
    return const Color.fromARGB(255, 0, 0, 0);
  }
}
