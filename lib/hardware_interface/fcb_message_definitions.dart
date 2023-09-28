import '../binary_parser/binary_parser.dart';
import '../constants.dart';

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

///Message ID to object mapping
class MessageOptions {
  static const Map<int, Object> options = {3: PositionData};
}

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

  BaseMessage(this.messageType, this.parameters);
}
