import 'dart:convert';
import 'dart:io';

mixin IODataClass<T> {
  late final File ioFile;

  late T ioData;

  // ignore: avoid_annotating_with_dynamic
  T fromMap(final dynamic value);

  T initValue();

  String ioDataToJson();

  String encode(final Object? value) => json.encode(value);

  void ioInitData(final String path, final String fileName) {
    ioFile = File('$path/$fileName');

    final fileExists = ioFile.existsSync();

    if (fileExists) {
      final fileData = ioFile.readAsStringSync();

      if (fileData.isNotEmpty)
        ioData = fromMap(json.decode(fileData));
      else
        ioData = initValue();
    } else {
      ioFile.createSync();
      ioData = initValue();
    }
  }

  Future<void> ioSaveData() => ioFile.writeAsString(ioDataToJson());

  Future<void> ioDeleteData() => ioFile.delete();
}
