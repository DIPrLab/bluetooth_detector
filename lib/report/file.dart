import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bluetooth_detector/report/report.dart';
import 'package:path_provider/path_provider.dart';
import 'package:bluetooth_detector/settings.dart';

Future<File> get _localFile async {
  final Directory directory = await getApplicationDocumentsDirectory();
  return File('${directory.path}/reports.json');
}

void write(Report report) async {
  final File file = await _localFile;
  final String data = report.toJson().toString();

  // Write the file
  await file.writeAsString('${data}');
  print(data);

  print("Saved!");
}

Future<Report> readReport() async {
  try {
    return await _localFile.then((file) {
      return file.readAsString().then((fileData) {
        return Report.fromJson(jsonDecode(fileData));
      });
    });
  } catch (e) {
    return Report({});
  }
}

Future<Settings> readSettings() async {
  Settings settings = Settings();
  settings.loadData();
  return settings;
}
