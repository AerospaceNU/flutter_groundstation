import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:args/command_runner.dart';

import '../serial/serial_none.dart' if (dart.library.io) '../serial/serial_desktop.dart' if (dart.library.html) '../serial/serial_web.dart';
import '../binary_parser/binary_parser.dart';

import 'base_hardware_interface.dart';

const int _TIMEOUT = 2000;
const String _ACK = "\r\nOK\r\n";
const String _COMPLETE = "\r\nDONE\r\n\r\n";
const String _HELP_COMMAND = "--help";
const String _OFFLOAD_HELP_COMMAND = "--offload -h";
const String _OFFLOAD_FLIGHT_COMMAND = "--offload -f {flight_num}";
const String _SIM_COMMAND = "--sim";
const String _SENSE_COMMAND = "--sense";
const String _SHUTDOWN_COMMAND = "--shutdown";
const String _ERASE_FLASH_COMMAND = "--erase";
const String _OUTPUT_DIR = "output";
final List<String> LOG_TYPES = List.unmodifiable(const ["FCB", "LINECUTTER"]);

/// Controls raw reading and writing to FCB command line via commands.
class FcbClientInterface extends BaseHardwareInterface {
  var serialInterface = getAbstractSerial();
  late var reader;
  /// Multi-stream wrapper for stream provided by [reader]. Allows for
  /// unsubscribing and resubscribing.
  late Stream<Uint8List> wrapper;
  static const String desiredPort = "/dev/pts/2"; // TODO: no idea what this supposed to be
  bool portOpen = false;

  CommandRunner<dynamic> runner = CommandRunner("FCB Client", "Flutter FCB Client Runner");

  int nextCheckTime = 0;
  int lastDataTime = 0;

  // initializes runner
  FcbClientInterface() {
    // runner.addCommand(_HelpCommand(this));
    runner.addCommand(_OffloadCommand(this));
    runner.addCommand(_SimulateCommand(this));
    runner.addCommand(_SenseCommand(this));
    runner.addCommand(_ShutdownCommand(this));
    runner.addCommand(_EraseCommand(this));
  }

  @override
  void runLoopOnce(Timer t) {
    print(serialInterface.serialPorts());
    if (portOpen && !enabled) {
      reader.close();
      portOpen = false;
    }

    if (!enabled) {
      return;
    }

    // checks for device connection
    int currentTime = DateTime.timestamp().millisecondsSinceEpoch;
    if (currentTime > nextCheckTime && !portOpen) {
      var ports = serialInterface.serialPorts();
      if (ports.contains(desiredPort)) {
        try {
          reader = createReader(desiredPort);
          reader.setBaudRate(115200);
          print("FCB Client: Opened port $desiredPort");
          portOpen = true;
          wrapper = resubscribeStream(reader.getIncomingStream()!);

          lastDataTime = currentTime + 5000;
        } catch (e) {
          print(e);
        }
      } else {
        print("FCB Client: Unable to open serial port $desiredPort, options are $ports");
      }
      nextCheckTime = currentTime + 1000;
    }

    if (portOpen && currentTime - lastDataTime > 2200) {
      reader.close();
      portOpen = false;
      print("FCB Client: Closed port");
    }
  }

  /// Runs a [command] for FCB CLI given a space-seperated string, then
  /// returns the value from [command], or NULL if no command matched.
  dynamic runCommand(String command) {
    return runner.run(command.split(" ")).catchError((err) {
      if (err is! UsageException) throw err;
      print(err);
      return null;
    });
  }
}

Future<void> _receiveAck(Stream<Uint8List> stream) async {
  String data = (await stream.first
      .timeout(const Duration(milliseconds: _TIMEOUT),
      onTimeout: () {
        print("FCB Client: Ack not received.");
        throw Error(); // TODO: make FCB_ACK_ERROR
      })).toUTF8();
  print("FCB Client: Ack got $data");
  if (data != _ACK) {
    throw Error(); // TODO: make variant ACK Error (extra message attached?)
  }
}

Future<Uint8List> _readUntilComplete(Stream<Uint8List> stream) async {
  List<int> flag = _COMPLETE.asUint8List().toList();
  List<int> data = [];
  int len = 0;
  await for (final event in stream.timeout(
      const Duration(milliseconds: _TIMEOUT),
      onTimeout: (sink) {
        print("FCB Client: Read Incomplete");
        sink.close();
        throw Error(); // TODO: make FCB_INCOMPLETE_ERROR
      })) {
    List<int> packet = event.toList();
    len += packet.length;
    data.addAll(packet);
    // might be possible to make simpler (just compare to packet)
    // has side effect of also being able to remove _COMPLETE flag
    // from data. Depends on packets are recieved.
    if (flag == data.sublist(len - flag.length)) {
      break;
    }
  }
  return Uint8List.fromList(data);
}

/// Doesn't work with current Argparse Library
class _HelpCommand extends Command<String> {
  @override String name = "help";
  @override String description = "Standard command line help string from FCB";
  final FcbClientInterface client;

  _HelpCommand(this.client);

  @override
  Future<String> run() async {
    client.wrapper.drain();
    client.reader.write("$_HELP_COMMAND\n".asUint8List());
    await _receiveAck(client.wrapper);
    Uint8List data = await _readUntilComplete(client.wrapper);
    return data.toUTF8().substring(0, data.length - _COMPLETE.length);
  }
}

class _OffloadCommand extends Command {
  @override String name = "offload";
  @override String description = "Offload data from FCB";
  final FcbClientInterface client;

  _OffloadCommand(this.client) {
    argParser.addOption("flight_name", mandatory: false, valueHelp: "str", help: "Name of flight, used for saving");
    argParser.addOption("flight_num", mandatory: false, valueHelp: "int", help: "Flight number to offload");
    argParser.addFlag("list", abbr: "l", defaultsTo: false, help: "Dump a list of all flights stored");
  }

  @override
  dynamic run() async {
    client.wrapper.drain();
    String command = argResults?['list']
        ? "$_OFFLOAD_HELP_COMMAND\n"
        : "$_OFFLOAD_FLIGHT_COMMAND ${argResults?['flight_num']}\n";

    client.reader.write(command.asUint8List());
    await _receiveAck(client.wrapper);
    Uint8List data = await _readUntilComplete(client.wrapper);

    return argResults?['list']
        ? _offloadHelp(data)
        : _offload(argResults?['flight_name'], argResults?['flight_num'], data);
  }

  String _offloadHelp(Uint8List data) {
    return data.toUTF8().substring(0, data.length - _COMPLETE.length);
  }

  // real unoptimized. stores crap in memory before dumping. IDK if even works
  // Does not support web or mobile devices.
  void _offload(String name, int num, Uint8List data) {
    File outputBinary = File("$_OUTPUT_DIR/$name-output.bin");
    if (outputBinary.existsSync()) {
      throw FileSystemException("File already exists.", outputBinary.absolute.path);
    }
    outputBinary.writeAsBytesSync(data.toList());
    RandomAccessFile readBin = outputBinary.openSync(mode: FileMode.read);

    File outputJson = File("$_OUTPUT_DIR/$name-metadata.json");
    if (outputBinary.existsSync()) {
      throw FileSystemException("File already exists.", outputJson.absolute.path);
    }
    String metadataFormatStr = "<${metadataFormat.values.join()}";
    Uint8List metadataRaw = readBin.readSync(getFormatLength(metadataFormatStr));
    List<dynamic> metadata = parseData(ByteData.view(metadataRaw.buffer), metadataFormatStr);

    // writes to output in json format
    StringBuffer json = StringBuffer("{\n");
    zip([metadataFormat.keys, metadata] as Iterable<Iterable>).forEach((element) {
      json.write("    \"${element[0]}\": ${element[1]}\n");
    });
    json.write("}");
    outputJson.writeAsStringSync(json.toString());

    List<File> outputCSVs = LOG_TYPES.map((type) => File("$_OUTPUT_DIR/$name-output-{$type}.csv")).toList();
    for (File file in outputCSVs) {
      if (file.existsSync()) throw FileSystemException("File already exists.", file.absolute.path);
    }
    List<String> logFormat = [];
    List<int> logSize = [];
    for (int i = 0; i < outputCSVs.length; i++) {
      logFormat[i] = "<${logDataFormat[i].values.join()}";
      logSize[i] = getFormatLength(logFormat[i]);
    }
    int logFullSize = logSize.reduce((a, b) => max(a, b));
    Uint8List buffer = Uint8List(logFullSize);
    while (true) {
      if (0 == readBin.readIntoSync(buffer, 0, 1)) {
        break;
      }
      int packetType = buffer.first;
      readBin.readIntoSync(buffer, 1, logSize[packetType] - 1);
      List<dynamic>? packet;
      try {
        packet = parseData(ByteData.view(buffer.buffer), logFormat[packetType]);
      } on IndexError {
        continue;
      }
      if (packet[1] < (2 << 32) - 1) { // apparently only keeps things if timestamp not 0xFF
        outputCSVs[packetType].writeAsStringSync(packet.join(','));
      }
    }
  }
}

class _SimulateCommand extends Command {
  @override String name = "sim";
  @override String description = "Simulate flight to FCB";
  final FcbClientInterface client;

  _SimulateCommand(this.client) {
    argParser.addOption("flight_title", mandatory: true, valueHelp: "path", help: "CSV file of flight to simulate");
  }
  
  @override
  dynamic run() async {
    // TODO: implement
    client.wrapper.drain();
    // client.reader.write("$_SIM_COMMAND}\n".asUint8List());
    // await _receiveAck(client.wrapper);
    // Uint8List data = await _readUntilComplete(client.wrapper);
  }
}

class _SenseCommand extends Command {
  @override String name = "sense";
  @override String description = "Reads back most recent sensor data";
  final FcbClientInterface client;

  _SenseCommand(this.client);

  @override
  dynamic run() async {
    // TODO: implement
    client.wrapper.drain();
    // client.reader.write("$_SENSE_COMMAND\n".asUint8List());
    // await _receiveAck(client.wrapper);
    // Uint8List data = await _readUntilComplete(client.wrapper);
  }
}

class _ShutdownCommand extends Command {
  @override String name = "shutdown";
  @override String description = "Prevent FCB from doing anything else. FCB won't actually shut off, but it won't do or respond to anything";
  final FcbClientInterface client;

  _ShutdownCommand(this.client);

  @override
  dynamic run() async {
    // TODO: implement
    client.wrapper.drain();
    // client.reader.write("$_SHUTDOWN_COMMAND\n".asUint8List());
    // await _receiveAck(client.wrapper);
    // Uint8List data = await _readUntilComplete(client.wrapper);

  }
}

class _EraseCommand extends Command {
  @override String name = "erase";
  @override String description = "Erases entire FCB flash";
  final FcbClientInterface client;

  _EraseCommand(this.client);

  @override
  void run() async {
    // TODO: implement
    client.wrapper.drain();
    // client.reader.write("$_ERASE_FLASH_COMMAND\n".asUint8List());
    // await _receiveAck(client.wrapper);
    // Uint8List data = await _readUntilComplete(client.wrapper);
  }
}

// source: https://stackoverflow.com/questions/70558849/can-i-listen-to-a-streamcontrollers-stream-multiple-times-but-not-more-than-on
/// Allows a stream to be listened to multiple times.
///
/// Returns a new stream which has the same events as [source],
/// but which can be listened to more than once.
/// Only allows one listener at a time, but when a listener
/// cancels, another can start listening and take over the stream.
///
/// If the [source] is a broadcast stream, the listener on
/// the source is cancelled while there is no listener on the
/// returned stream.
/// If the [source] is not a broadcast stream, the subscription
/// on the source stream is maintained, but paused, while there
/// is no listener on the returned stream.
///
/// Only listens on the [source] stream when the returned stream
/// is listened to.
Stream<T> resubscribeStream<T>(Stream<T> source) {
  MultiStreamController<T>? current;
  StreamSubscription<T>? sourceSubscription;
  bool isDone = false;
  void add(T value) {
    current!.addSync(value);
  }

  void addError(Object error, StackTrace stack) {
    current!.addErrorSync(error, stack);
  }

  void close() {
    isDone = true;
    current!.close();
    current = null;
    sourceSubscription = null;
  }

  return Stream<T>.multi((controller) {
    if (isDone) {
      controller.close(); // Or throw StateError("Stream has ended");
      return;
    }
    if (current != null) throw StateError("Has listener");
    current = controller;
    var subscription = sourceSubscription ??=
        source.listen(add, onError: addError, onDone: close);
    subscription.resume();
    controller
      ..onPause = subscription.pause
      ..onResume = subscription.resume
      ..onCancel = () {
        current = null;
        if (source.isBroadcast) {
          sourceSubscription = null;
          return subscription.cancel();
        }
        subscription.pause();
        return null;
      };
  });
}

// Source: https://pub.dev/packages/quiver
Iterable<List<T>> zip<T>(Iterable<Iterable<T>> iterables) sync* {
  if (iterables.isEmpty) return;
  final iterators = iterables.map((e) => e.iterator).toList(growable: false);
  while (iterators.every((e) => e.moveNext())) {
    yield iterators.map((e) => e.current).toList(growable: false);
  }
}

const Map<String, String> metadataFormat = {
 "pressure_ref"         : "d",
 "gravity_ref"          : "B",
 "launched"             : "B",
 "gps_timestamp"        : "Q",
 "apogee_timestamp"     : "I",
 "trigger_fire_status"  : "h",
 "gyro_offset_x"        : "f",
 "gyro_offset_y"        : "f",
 "gyro_offset_z"        : "f",
};

const Map<String, String> sensorDataFormat = {
  "timestamp_ms"        : "L",
  "imu1_accel_x_raw"    : "h",
  "imu1_accel_y_raw"    : "h",
  "imu1_accel_z_raw"    : "h",
  "imu1_accel_x"        : "d",
  "imu1_accel_y"        : "d",
  "imu1_accel_z"        : "d",
  "imu1_gyro_x_raw"     : "h",
  "imu1_gyro_y_raw"     : "h",
  "imu1_gyro_z_raw"     : "h",
  "imu1_gyro_x"         : "d",
  "imu1_gyro_y"         : "d",
  "imu1_gyro_z"         : "d",
  "imu1_mag_x_raw"      : "h",
  "imu1_mag_y_raw"      : "h",
  "imu1_mag_z_raw"      : "h",
  "imu1_mag_x"          : "d",
  "imu1_mag_y"          : "d",
  "imu1_mag_z"          : "d",
  "imu2_accel_x_raw"    : "h",
  "imu2_accel_y_raw"    : "h",
  "imu2_accel_z_raw"    : "h",
  "imu2_accel_x"        : "d",
  "imu2_accel_y"        : "d",
  "imu2_accel_z"        : "d",
  "imu2_gyro_x_raw"     : "h",
  "imu2_gyro_y_raw"     : "h",
  "imu2_gyro_z_raw"     : "h",
  "imu2_gyro_x"         : "d",
  "imu2_gyro_y"         : "d",
  "imu2_gyro_z"         : "d",
  "imu2_mag_x_raw"      : "h",
  "imu2_mag_y_raw"      : "h",
  "imu2_mag_z_raw"      : "h",
  "imu2_mag_x"          : "d",
  "imu2_mag_y"          : "d",
  "imu2_mag_z"          : "d",
  "high_g_accel_x_raw"  : "h",
  "high_g_accel_y_raw"  : "h",
  "high_g_accel_z_raw"  : "h",
  "high_g_accel_x"      : "d",
  "high_g_accel_y"      : "d",
  "high_g_accel_z"      : "d",
  "baro1_temp"          : "d",
  "baro1_pres"          : "d",
  "baro2_temp"          : "d",
  "baro2_pres"          : "d",
  "gps_lat"             : "f",
  "gps_long"            : "f",
  "gps_alt"             : "f",
  "gps_fix_quality"     : "B",
  "gps_sats_tracked"    : "B",
  "gps_hdop"            : "f",
  "gps_timestamp"       : "Q",
  "gps_seconds"         : "i",
  "gps_microseconds"    : "i",
  "gps_minutes"         : "i",
  "gps_hours"           : "i",
  "gps_day"             : "i",
  "gps_month"           : "i",
  "gps_year"            : "i",
  "battery_voltage"     : "d",
  "pyro_continuity"     : "??????",
};

// logDataFormat[0] = FCB Data Format.
// logDataFormat[1] = Line Cutter Data Format.
const List<Map<String, String>> logDataFormat = [{
  "packetType"          : "B",
  "timestamp_ms"        : "I",
  "imu1_accel_x"        : "h",
  "imu1_accel_y"        : "h",
  "imu1_accel_z"        : "h",
  "imu1_gyro_x"         : "h",
  "imu1_gyro_y"         : "h",
  "imu1_gyro_z"         : "h",
  "imu1_mag_x"          : "h",
  "imu1_mag_y"          : "h",
  "imu1_mag_z"          : "h",
  "imu2_accel_x"        : "h",
  "imu2_accel_y"        : "h",
  "imu2_accel_z"        : "h",
  "imu2_gyro_x"         : "h",
  "imu2_gyro_y"         : "h",
  "imu2_gyro_z"         : "h",
  "imu2_mag_x"          : "h",
  "imu2_mag_y"          : "h",
  "imu2_mag_z"          : "h",
  "high_g_accel_x"      : "h",
  "high_g_accel_y"      : "h",
  "high_g_accel_z"      : "h",
  "baro1_temp"          : "d",
  "baro1_pres"          : "d",
  "baro2_temp"          : "d",
  "baro2_pres"          : "d",
  "gps_lat"             : "f",
  "gps_long"            : "f",
  "gps_alt"             : "f",
  "gps_fix_quality"     : "B",
  "gps_sats_tracked"    : "B",
  "gps_hdop"            : "f",
  "battery_voltage"     : "d",
  "pyro_cont"           : "B",
  "trigger_status"      : "H",
  "heading"             : "d",
  "vtg"                 : "d",
  "pos_x"               : "d",
  "pos_y"               : "d",
  "pos_z"               : "d",
  "vel_x"               : "d",
  "vel_y"               : "d",
  "vel_z"               : "d",
  "acc_x"               : "d",
  "acc_y"               : "d",
  "acc_z"               : "d",
  "q_x"                 : "d",
  "q_y"                 : "d",
  "q_z"                 : "d",
  "q_w"                 : "d",
  "state"               : "B",
}, {
  "packetType"          : "B",
  "timestamp_s"         : "I",
  "timestamp_ms"        : "I",
  "lineCutterNumber"    : "B",
  "state"               : "B",
  "timestamp"           : "I",
  "pressure"            : "I",
  "altitude"            : "f",
  "deltaAltitude"       : "f",
  "temperature"         : "f",
  "accelNorm"           : "f",
  "battery"             : "f",
  "cutSense1"           : "H",
  "cutSense2"           : "H",
  "currentSense"        : "H",
  "photoresistor"       : "H",
}];