import 'dart:typed_data';

import '../../binary_parser/binary_parser.dart';

ByteData createRadioBandCommandMessage(destination, targetRadio, channel) {
  return packData("<BHBBb", [destination, 3, 1, targetRadio, channel]); //destination, length, command id, target radio, channel
}
