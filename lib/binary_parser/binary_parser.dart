// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

///
/// Duplicates the python struct library
///
/// I know that this is kinda hard to change, its just a huge pain to write it any better
///

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

//Put type length here
int getLength(String dataType) {
  switch (dataType) {
    case BinaryTypes.CHAR_TYPE:
      return 1;
    case BinaryTypes.INT_8_TYPE:
      return 1;
    case BinaryTypes.UINT_8_TYPE:
      return 1;
    case BinaryTypes.BOOL_TYPE:
      return 1;
    case BinaryTypes.INT_16_TYPE:
      return 2;
    case BinaryTypes.UINT_16_TYPE:
      return 2;
    case BinaryTypes.INT_32_TYPE:
    case 'l':
      return 4;
    case BinaryTypes.UINT_32_TYPE:
    case 'L':
      return 4;
    case BinaryTypes.FLOAT_32_TYPE:
      return 4;
    case BinaryTypes.FLOAT_64_TYPE:
      return 8;
    default:
      return 0;
  }
}

int getFormatLength(String format) {
  int length = 0;

  for (var i = 0; i < format.length; i++) {
    length += getLength(format[i]);
  }

  return length;
}

//Add case to switch statement here
List parseData(ByteData data, String format) {
  var output = [];
  int index = 0;

  var endianness = Endian.big;
  if (format[0] == "<") {
    endianness = Endian.little;
    format = format.substring(1);
  } else if (format[0] == ">") {
    endianness = Endian.big;
    format = format.substring(1);
  }

  for (var i = 0; i < format.length; i++) {
    var character = format[i];

    switch (character) {
      case BinaryTypes.CHAR_TYPE:
        output.add(String.fromCharCode(data.getUint8(index)));
        break;
      case BinaryTypes.INT_8_TYPE:
        output.add(data.getInt8(index));
        break;
      case BinaryTypes.UINT_8_TYPE:
        output.add(data.getUint8(index));
        break;
      case BinaryTypes.BOOL_TYPE: //Bool
        output.add(data.getUint8(index) > 0);
        break;
      case BinaryTypes.INT_16_TYPE:
        output.add(data.getUint16(index, endianness));
      case BinaryTypes.UINT_16_TYPE:
        output.add(data.getUint16(index, endianness));
      case BinaryTypes.INT_32_TYPE:
      case 'l':
        output.add(data.getInt32(index, endianness));
        break;
      case BinaryTypes.UINT_32_TYPE:
      case 'L':
        output.add(data.getUint32(index, endianness));
        break;
      case BinaryTypes.FLOAT_32_TYPE:
        output.add(data.getFloat32(index, endianness));
        break;
      case BinaryTypes.FLOAT_64_TYPE:
        output.add(data.getFloat64(index, endianness));
        break;
      default:
        print("Unknown binary format specifier $character");
        break;
    }

    index += getLength(character);
  }

  return output;
}

ByteData packData(String format, List data) {
  var endianness = Endian.big;
  if (format[0] == "<") {
    endianness = Endian.little;
    format = format.substring(1);
  } else if (format[0] == ">") {
    endianness = Endian.big;
    format = format.substring(1);
  }

  //Get length of pack
  int index = 0;
  var length = getFormatLength(format);
  var output = ByteData(length);

  for (var i = 0; i < format.length; i++) {
    var character = format[i];
    var value = data[i];

    switch (character) {
      case BinaryTypes.CHAR_TYPE:
        output.setUint8(index, value);
        break;
      case BinaryTypes.INT_8_TYPE:
        output.setInt8(index, value);
        break;
      case BinaryTypes.UINT_8_TYPE:
        output.setUint8(index, value);
        break;
      case BinaryTypes.BOOL_TYPE: //Bool
        output.setUint8(index, value);
        break;
      case BinaryTypes.INT_16_TYPE:
        output.setUint16(index, value, endianness);
      case BinaryTypes.UINT_16_TYPE:
        output.setUint16(index, value, endianness);
      case BinaryTypes.INT_32_TYPE:
      case 'l':
        output.setInt32(index, value, endianness);
        break;
      case BinaryTypes.UINT_32_TYPE:
      case 'L':
        output.setUint32(index, value, endianness);
        break;
      case BinaryTypes.FLOAT_32_TYPE:
        output.setFloat32(index, value, endianness);
        break;
      case BinaryTypes.FLOAT_64_TYPE:
        output.setFloat64(index, value, endianness);
        break;
      default:
        print("Unknown binary format specifier $character");
        break;
    }

    index += getLength(character);
  }

  return output;
}

// QOL extension methods
extension StringToBinary on String {
  /// The UTF-8 encoded representation of this string as [ByteData].
  ByteData asByteData() {
    List<int> encoded = utf8.encode(this);
    ByteData output = ByteData(length);
    for (int i = 0; i < length; i++) {
      output.setUint8(i, encoded[i]);
    }
    return output;
  }

  /// The UTF-8 encoded representation of this string as a [Uint8List].
  Uint8List asUint8List() {
    return Uint8List.fromList(utf8.encode(this));
  }
}

extension ByteDataAsUTF8 on ByteData {
  /// String representation of this [ByteData] interpreted as UTF-8 encoded
  /// characters.
  String toUTF8() {
    return utf8.decode(buffer.asInt8List().toList(), allowMalformed: true);
  }
}

extension Uint8ListAsUTF8 on Uint8List {
  /// String representation of this [Uint8List] interpreted as UTF-8 encoded
  /// characters.
  String toUTF8() {
    return utf8.decode(toList(), allowMalformed: true);
  }
}