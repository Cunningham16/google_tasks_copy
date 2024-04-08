import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:google_tasks/data/entities/category.entity.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

part 'database.g.dart';

@DataClassName("TaskCategory")
class TaskCategories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  BoolColumn get isDeletable =>
      boolean().named('is_deletable').withDefault(const Constant(true))();
  IntColumn get sortType => integer().withDefault(const Constant(0))();
}

@DataClassName("TaskItem")
class TaskItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get content => text().named('body')();
  IntColumn get category => integer()
      .nullable()
      .named('category_id')
      .references(TaskCategories, #id)();
  BoolColumn get isCompleted => boolean().named('is_completed')();
  BoolColumn get isFavorite => boolean().named('is_favorite')();
  TextColumn get date => text()();
  TextColumn get time => text()();
}

@DriftDatabase(tables: [TaskItems, TaskCategories])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  Future<void> saveCategory(
      TaskCategoriesCompanion taskCategoriesCompanion) async {
    await into(taskCategories).insertOnConflictUpdate(taskCategoriesCompanion);
  }

  Future<void> updateCategory(
      int id, TaskCategoriesCompanion taskCategoriesCompanion) async {
    await (update(taskCategories)..where((tbl) => tbl.id.equals(id)))
        .write(taskCategoriesCompanion);
  }

  Future<void> deleteCategory(int id) async {
    await (delete(taskItems)..where((tbl) => tbl.category.equals(id))).go();
    await (delete(taskCategories)
          ..where((tbl) => tbl.id.equals(id) & tbl.isDeletable.isValue(true)))
        .go();
  }

  Stream<List<TaskCategory>> watchCategories() {
    return (select(taskCategories)).watch();
  }

  Future<List<TaskCategory>> getCategories() {
    return (select(taskCategories)).get();
  }

  Future<void> saveTask(TaskItemsCompanion taskItemsCompanion) async {
    await into(taskItems).insertOnConflictUpdate(taskItemsCompanion);
  }

  Future<void> deleleTask(int id) async {
    await (delete(taskItems)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<void> updateTask(int id, TaskItemsCompanion taskItemsCompanion) async {
    await (update(taskItems)..where((tbl) => tbl.id.equals(id)))
        .write(taskItemsCompanion);
  }

  Future<TaskItem?> querySingleTask(int taskId) async {
    return (select(taskItems)..where((tbl) => tbl.id.equals(taskId)))
        .getSingleOrNull();
  }

  Future<List<TaskItem>> queryTaskByFavorites() async {
    return (select(taskItems)..where((tbl) => tbl.isFavorite.isValue(true)))
        .get();
  }

  Stream<List<TaskItem>> watchAllTasks() {
    return (select(taskItems)).watch();
  }

  Future<void> deleteTable() async {
    return transaction(() async {
      for (final table in allTables) {
        await delete(table).go();
      }
    });
  }

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(onCreate: (Migrator m) async {
      await m.createAll();
      await into(taskCategories).insert(
          const CategoryEntity(name: "Избранное", isDeleteable: false)
              .toCompanion());
      await into(taskCategories).insert(
          const CategoryEntity(name: "Мои задачи", isDeleteable: false)
              .toCompanion());
    });
  }

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    final cachebase = (await getTemporaryDirectory()).path;

    sqlite3.tempDirectory = cachebase;

    return NativeDatabase.createInBackground(file);
  });
}
