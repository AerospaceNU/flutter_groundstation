import 'dart:core';

import 'package:flutter/foundation.dart';

import '../../binary_parser/binary_parser.dart';
import '../../constants.dart';

class OrientationMessage extends BaseMessage {
  OrientationMessage()
      : super("Orientation", [
          ParameterDescription(BinaryTypes.UINT_8_TYPE, Constants.fcbStateNumber),
          ParameterDescription(BinaryTypes.INT_8_TYPE, Constants.qW, multiplier: 0.01),
          ParameterDescription(BinaryTypes.INT_8_TYPE, Constants.qX, multiplier: 0.01),
          ParameterDescription(BinaryTypes.INT_8_TYPE, Constants.qY, multiplier: 0.01),
          ParameterDescription(BinaryTypes.INT_8_TYPE, Constants.qZ, multiplier: 0.01),
          ParameterDescription(BinaryTypes.FLOAT_32_TYPE, Constants.gyroX),
          ParameterDescription(BinaryTypes.FLOAT_32_TYPE, Constants.gyroY),
          ParameterDescription(BinaryTypes.FLOAT_32_TYPE, Constants.gyroZ),
          ParameterDescription(BinaryTypes.FLOAT_32_TYPE, Constants.accelerometerX),
          ParameterDescription(BinaryTypes.FLOAT_32_TYPE, Constants.accelerometerY),
          ParameterDescription(BinaryTypes.FLOAT_32_TYPE, Constants.accelerometerZ),
          ParameterDescription(BinaryTypes.FLOAT_32_TYPE, Constants.magnetometerX),
          ParameterDescription(BinaryTypes.FLOAT_32_TYPE, Constants.magnetometerY),
          ParameterDescription(BinaryTypes.FLOAT_32_TYPE, Constants.magnetometerZ),
          ParameterDescription(BinaryTypes.INT_16_TYPE, Constants.angleVertical, multiplier: 0.1),
        ]);
}

class PositionData extends BaseMessage {
  PositionData()
      : super("Position Data", [
          ParameterDescription(BinaryTypes.FLOAT_32_TYPE, Constants.temperature),
          ParameterDescription(BinaryTypes.FLOAT_32_TYPE, Constants.altitude),
          ParameterDescription(BinaryTypes.FLOAT_32_TYPE, Constants.verticalSpeed),
          ParameterDescription(BinaryTypes.FLOAT_32_TYPE, Constants.latitude),
          ParameterDescription(BinaryTypes.FLOAT_32_TYPE, Constants.longitude),
          ParameterDescription(BinaryTypes.FLOAT_32_TYPE, Constants.gpsAltitude),
          ParameterDescription(BinaryTypes.FLOAT_32_TYPE, Constants.batteryVoltage),
          ParameterDescription(BinaryTypes.FLOAT_32_TYPE, Constants.groundSpeed, multiplier: 0.514444),
          ParameterDescription(BinaryTypes.FLOAT_32_TYPE, Constants.courseOverGround),
          ParameterDescription(BinaryTypes.UINT_32_TYPE, Constants.gpsTime, alternateFormatType: "TIME"),
          ParameterDescription(BinaryTypes.UINT_8_TYPE, Constants.gpsSatellites),
          ParameterDescription(BinaryTypes.UINT_8_TYPE, Constants.fcbStateNumber),
          ParameterDescription(BinaryTypes.UINT_8_TYPE, Constants.bluetoothConnection),
        ]);
}

class AltitudeInfoMessage extends BaseMessage {
  AltitudeInfoMessage()
      : super("Altitude Info", [
          ParameterDescription(BinaryTypes.FLOAT_32_TYPE, Constants.barometer1Pressure),
          ParameterDescription(BinaryTypes.FLOAT_32_TYPE, Constants.barometer2Pressure),
          ParameterDescription(BinaryTypes.FLOAT_32_TYPE, Constants.pressureReference),
          ParameterDescription(BinaryTypes.FLOAT_32_TYPE, Constants.groundElevation),
          ParameterDescription(BinaryTypes.FLOAT_32_TYPE, Constants.groundTemperature),
          ParameterDescription(BinaryTypes.FLOAT_32_TYPE, Constants.pitotPressure),
        ]);
}

class PyroInfo extends BaseMessage {
  PyroInfo()
      : super("Pyro Info", [
          ParameterDescription(BinaryTypes.UINT_8_TYPE, Constants.pyroContinuity),
          ParameterDescription(BinaryTypes.UINT_16_TYPE, Constants.pyroFireStatus), //TODO: We need a special parse function
          ParameterDescription(BinaryTypes.UINT_8_TYPE, Constants.flashUsage),
        ]);
}

class GroundStationMessage extends BaseMessage {
  GroundStationMessage()
      : super("GroundStation Message", [
          ParameterDescription(BinaryTypes.FLOAT_32_TYPE, Constants.groundStationLatitude),
          ParameterDescription(BinaryTypes.FLOAT_32_TYPE, Constants.groundStationLongitude),
          ParameterDescription(BinaryTypes.FLOAT_32_TYPE, Constants.groundStationAltitude),
          ParameterDescription(BinaryTypes.FLOAT_64_TYPE, Constants.groundStationPressure),
          ParameterDescription(BinaryTypes.FLOAT_64_TYPE, Constants.groundStationTemperature),
        ]);
}

///Message ID to object mapping
class MessageOptions {
  static Map<int, BaseMessage> options = {
    2: OrientationMessage(),
    3: PositionData(),
    6: AltitudeInfoMessage(),
    7: PyroInfo(),
    200: GroundStationMessage(),
  };
}

//2: ["Orientation", OrientationMessage],
//4: ["Line Cutter Data ", LineCutterMessage],
//5: ["CLI Data", CLIDataMessage],
//8: ["Line Cutter Vars ", LineCutterVarsMessage],
//9: ["GPS USB String", GpsUsbDataMessage],

///Parse function
Map<String, Object> parseMessage(int packetType, ByteData data) {
  var messageDict = <String, Object>{};

  if (MessageOptions.options.containsKey(packetType)) {
    var packetObject = MessageOptions.options[packetType];
    var parsedBinary = parseData(data, packetObject!.binaryFormatString);
    messageDict["message_type"] = packetObject.messageType;

    for (var i = 0; i < packetObject.parameters.length; i++) {
      var parameter = packetObject.parameters[i];
      var value = parsedBinary[i];

      //TODO: Alternate format types (date & latlon)
      if (value is num) {
        messageDict[parameter.databaseKey] = value * parameter.multiplier;
      } else {
        messageDict[parameter.databaseKey] = value;
      }
    }
  } else {
    print("Unknown message type $packetType");
  }

  return messageDict;
}

///Other helper stuff
Object? getMessageClass(int messageType) {
  return MessageOptions.options[messageType];
}

///Generics that get used above
class ParameterDescription {
  String dataType;
  String databaseKey;
  String alternateFormatType;
  num multiplier;

  ParameterDescription(this.dataType, this.databaseKey, {this.multiplier = 1, this.alternateFormatType = "_"});
}

class BaseMessage {
  List<ParameterDescription> parameters;
  String messageType;
  String binaryFormatString = "<";

  BaseMessage(this.messageType, this.parameters) {
    for (var parameter in parameters) {
      binaryFormatString += parameter.dataType;
    }
  }
}
