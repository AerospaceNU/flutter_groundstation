import 'dart:io';
import 'dart:async';
import 'dart:convert';

main(List arguments) {
  final File file = new File("~/Downloads/sprucegoose-11-19-2-output-FCB-post.csv");

  Stream<List> inputStream = file.openRead();

  inputStream
      .transform(utf8.decoder)          // Decode bytes to UTF-8.
      .transform(new LineSplitter())    // Convert stream to individual lines.
      .transform(new JsonDecoder());
      // .transform(new JsonDecoder()); ,
      //  onDone: () { print('File is now closed.'); },
      //  onError: (e) { print(e.toString()); });
}