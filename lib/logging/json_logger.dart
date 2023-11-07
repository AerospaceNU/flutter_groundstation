import 'dart:convert';
import 'dart:io';

void main() {
  JsonLogger logger = JsonLogger("yo", "logs/outputFile.txt");
  logger.log("alt", 3.0);
  logger.log("temp", 5);
  logger.log("temp2", {
    "adf" : [1,"2",3],

  });
  logger.log("ang", false);
  logger.push();
  logger.log("ang", false);
  logger.push();
}

class JsonLogger {
  final String name;
  final String outputFileName;
  final File outputFile;
  var runningData = {};

  JsonLogger(this.name, this.outputFileName) : outputFile = File(outputFileName);

  void push() {
    print("${jsonEncode(runningData)}\n");
    outputFile.writeAsString("${jsonEncode(runningData)}\n", flush: true);
    runningData = {};
  }

  void log<T>(String key, T data) {
    runningData[key] = data;
  }

}