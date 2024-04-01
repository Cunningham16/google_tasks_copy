import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:google_tasks/data/entities/category.entity.dart';
import 'package:google_tasks/data/entities/task.entity.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

part 'database.g.dart';

@UseRowClass(CategoryEntity)
class TaskCategories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  BoolColumn get isDeletable =>
      boolean().named('is_deletable').withDefault(const Constant(true))();
  IntColumn get sortType => integer().withDefault(const Constant(0))();
}

@UseRowClass(TaskEntity)
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

  Future<void> saveCategory(CategoryEntity categoryEntity) async {
    await into(taskCategories)
        .insertOnConflictUpdate(categoryEntity.toCompanion());
  }

  Future<void> updateCategory(int id, CategoryEntity newCategory) async {
    await (update(taskCategories)..where((tbl) => tbl.id.equals(id)))
        .write(newCategory.toCompanion());
  }

  Future<void> deleteCategory(int id) async {
    await (delete(taskCategories)
          ..where((tbl) => tbl.id.equals(id) | tbl.isDeletable.isValue(true)))
        .go();
    await (delete(taskItems)..where((tbl) => tbl.category.equals(id))).go();
  }

  Stream<List<CategoryEntity>> queryCategories() {
    return (select(taskCategories)).watch();
  }

  Future<void> saveTask(TaskEntity entity) async {
    await into(taskItems).insertOnConflictUpdate(entity.toCompanion());
  }

  Future<void> deleleTask(int id) async {
    await (delete(taskItems)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<void> updateTask(int id, TaskEntity taskEntity) async {
    await (update(taskItems)..where((tbl) => tbl.id.equals(id)))
        .write(taskEntity.toCompanion());
  }

  Future<List<TaskEntity>> queryTasksByCategory(int categoryId) async {
    return (select(taskItems)..where((tbl) => tbl.category.equals(categoryId)))
        .get();
  }

  Future<TaskEntity?> querySingleTask(int taskId) async {
    return (select(taskItems)..where((tbl) => tbl.id.equals(taskId)))
        .getSingleOrNull();
  }

  Future<List<TaskEntity>> queryTaskByFavorites() async {
    return (select(taskItems)..where((tbl) => tbl.isFavorite.isValue(true)))
        .get();
  }

  Stream<List<TaskEntity>> queryAllTasks() {
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
