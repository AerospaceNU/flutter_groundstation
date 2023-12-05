import 'package:flutter/material.dart';

//Aparently there's literally no library that does this
var colorNames = {
  "red": Colors.red,
  "green": Colors.green,
  "blue": Colors.blue,
  "magenta": Colors.purple,
  "yellow": Colors.yellow,
  "amber": Colors.amber,
  "black": Colors.black,
  "brown": Colors.brown,
  "cyan": Colors.cyan,
  "grey": Colors.grey,
  "gray": Colors.grey,
  "white": Colors.white,
  "teal": Colors.teal,
  "pink": Colors.pink,
  "orange": Colors.orange,
  "lime": Colors.lime,
};

Color? colorFromName(String colorName) {
  if (colorNames.keys.contains(colorName)) {
    return colorNames[colorName]?.withAlpha(255);
  } else {
    print("Unknown color $colorName");
    return const Color.fromARGB(255, 0, 0, 0);
  }
}
