import 'package:flutter_groundstation/data_stream.dart';
import 'package:file_picker/file_picker.dart';
import 'base_hardware_interface.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';

class FileInterface extends BaseHardwareInterface {
  Stream<String>? stringStream;
  File? file;
  List<PlatformFile>? _paths;

  @override
  void runWhileEnabled() {
    if (file == null) {
      print("no file");

      //file picker here - somehow runs it twice who knows why
      _pickFiles();
      if (_paths != null) {
        file = File(_paths!.single.path!);
        stringStream =
            file!.openRead().transform(utf8.decoder).transform(LineSplitter());
      } else {
        // User canceled the picker
        print("cancelled the file picker");
      }
    } else {
      //addStream has an error:"Cannot add new events while doing an addStream"
      // should this instead just add one packet from stringStream? how?
      DataStream.streamcontroller.addStream(stringStream!);
    }
  }

  void _pickFiles() async {
    _paths = (await FilePicker.platform.pickFiles(
      onFileLoading: (FilePickerStatus status) => print(status),
    ))
        ?.files;
  }
}
