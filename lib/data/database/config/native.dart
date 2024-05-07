import 'dart:io';

import 'package:drift/native.dart';
import "package:path_provider/path_provider.dart" as paths;
import 'package:drift/drift.dart';
import "package:path/path.dart" as p;
import 'package:sqlite3/sqlite3.dart';

Future<File> get databaseFile async {
  final appDir = await paths.getApplicationDocumentsDirectory();
  final dbPath = p.join(appDir.path, 'tasks.db');
  return File(dbPath);
}

DatabaseConnection connect() {
  return DatabaseConnection.delayed(Future(() async {
    if (Platform.isAndroid) {
      final cachebase = (await paths.getTemporaryDirectory()).path;

      sqlite3.tempDirectory = cachebase;
    }
    return NativeDatabase.createBackgroundConnection(await databaseFile);
  }));
}
