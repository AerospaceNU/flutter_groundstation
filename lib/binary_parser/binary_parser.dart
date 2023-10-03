// ignore_for_file: constant_identifier_names

import 'package:flutter/foundation.dart';

/// Duplicates the python struct library

//Put type definitions here
class BinaryTypes {
  static const BOOL_TYPE = "?";
  static const CHAR_TYPE = "c";
  static const INT_8_TYPE = "b";
  static const UINT_8_TYPE = "B";
  static const INT_16_TYPE = "h";
  static const UINT_16_TYPE = "H";
  static const INT_32_TYPE = 'i';
  static const UINT_32_TYPE = "I";
  static const FLOAT_32_TYPE = "f";
  static const FLOAT_64_TYPE = "d";
}

//Add case to switch statement here
List parseData(ByteData data, String format) {
  var output = [];
  int index = 0;

  var endianness = Endian.big;
  if (format[0] == "<") {
    endianness = Endian.little;
    format = format.substring(1);
  } else if (format[1] == ">") {
    endianness = Endian.big;
    format = format.substring(1);
  }

  for (var i = 0; i < format.length; i++) {
    var character = format[i];

    switch (character) {
      case BinaryTypes.CHAR_TYPE:
        output.add(String.fromCharCode(data.getUint8(index)));
        index += 1;
        break;
      case BinaryTypes.INT_8_TYPE:
        output.add(data.getInt8(index));
        index += 1;
        break;
      case BinaryTypes.UINT_8_TYPE:
        output.add(data.getUint8(index));
        index += 1;
        break;
      case BinaryTypes.BOOL_TYPE: //Bool
        output.add(data.getUint8(index) > 0);
        index += 1;
        break;
      case BinaryTypes.INT_16_TYPE:
        output.add(data.getUint16(index, endianness));
        index += 2;
      case BinaryTypes.UINT_16_TYPE:
        output.add(data.getUint16(index, endianness));
        index += 2;
      case BinaryTypes.INT_32_TYPE:
      case 'l':
        output.add(data.getInt32(index, endianness));
        index += 4;
        break;
      case BinaryTypes.UINT_32_TYPE:
      case 'L':
        output.add(data.getUint32(index, endianness));
        index += 4;
        break;
      case BinaryTypes.FLOAT_32_TYPE:
        output.add(data.getFloat32(index, endianness));
        index += 4;
        break;
      case BinaryTypes.FLOAT_64_TYPE:
        output.add(data.getFloat64(index, endianness));
        index += 8;
        break;
      default:
        print("Unknown binary format specifier $character");
        break;
    }
  }

  return output;
}
