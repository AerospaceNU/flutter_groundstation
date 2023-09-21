import 'package:flutter/foundation.dart';

/// Duplicates the python struct library

List parseData(ByteData data, String format) {
  var output = [];
  int index = 0;

  for (var i = 0; i < format.length; i++) {
    var character = format[i];

    switch (character) {
      case 'f':
        output.add(data.getFloat32(index));
        index += 4;
        break;
      case 'd':
        output.add(data.getFloat64(index));
        index += 8;
        break;
      case 'i':
      case 'l':
        output.add(data.getInt32(index));
        index += 4;
        break;
    }
  }

  return output;
}
