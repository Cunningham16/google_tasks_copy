import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:google_tasks/feature/shared/sort_types.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:rxdart/rxdart.dart';
import 'package:sqlite3/sqlite3.dart';

part 'database.g.dart';

@DataClassName("TaskCategory")
class TaskCategories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  BoolColumn get isDeletable =>
      boolean().named('is_deletable').withDefault(const Constant(true))();
  IntColumn get sortType => intEnum<SortTypes>()();
}

@DataClassName("TaskItem")
class TaskItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get content => text().named('body')();
  IntColumn get category =>
      integer().named('category_id').references(TaskCategories, #id)();
  BoolColumn get isCompleted => boolean()();
  BoolColumn get isFavorite => boolean()();
  //Костыль: дата при вставке может быть null, но если значение снова попытаться обратить в null он просто шлет тебя нахер
  //Именно с этой целью делается дата 1 год нашей эры, он будет означать пустое значение даты
  DateTimeColumn get date => dateTime().withDefault(Constant(DateTime(1)))();
  DateTimeColumn get whenMarked =>
      dateTime().named("when_marked").withDefault(Constant(DateTime(1)))();
  IntColumn get position => integer().withDefault(const Constant(-1))();
}

class TasksWithCategories {
  const TasksWithCategories(this.taskCategory, this.taskItems);

  final TaskCategory taskCategory;
  final List<TaskItem> taskItems;
}

@DriftDatabase(tables: [TaskItems, TaskCategories])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  //Не думал, что придется добавлять RxDart, но он здорово выручил здесь
  Stream<List<TasksWithCategories>> queryCategoriesWithTasks() {
    final categories = select(taskCategories).watch();
    final tasks = select(taskItems).watch();

    return Rx.combineLatest2(
        categories,
        tasks,
        (categoryList, b) => categoryList.map((category) {
              List<TaskItem> tasksOfCategory;
              if (categoryList.indexOf(category) == 0) {
                tasksOfCategory =
                    b.where((element) => element.isFavorite == true).toList();
              } else {
                tasksOfCategory = b
                    .where((element) => element.category == category.id)
                    .toList();
              }

              return TasksWithCategories(category, tasksOfCategory);
            }).toList());
  }

  Future<TaskCategory> getCategoryById(int id) async {
    return (select(taskCategories)..where((tbl) => tbl.id.equals(id)))
        .getSingle();
  }

  Future<void> saveCategory(
      TaskCategoriesCompanion taskCategoriesCompanion) async {
    await into(taskCategories).insert(taskCategoriesCompanion);
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

  Stream<List<TaskItem>> watchTasks() {
    return (select(taskItems)).watch();
  }

  Future<void> saveTask(TaskItemsCompanion taskItemsCompanion) async {
    await into(taskItems).insert(taskItemsCompanion);
  }

  Future<void> deleteTask(int id) async {
    await (delete(taskItems)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<void> updateTask(int id, TaskItemsCompanion taskItemsCompanion) async {
    await (update(taskItems)..where((tbl) => tbl.id.equals(id)))
        .write(taskItemsCompanion);
  }

  Future<void> clearCompletedTasks(int categoryId) async {
    await (delete(taskItems)
          ..where((tbl) =>
              tbl.category.equals(categoryId) & tbl.isCompleted.isValue(true)))
        .go();
  }

  Stream<TaskItem> watchSingleTask(int taskId) {
    return (select(taskItems)..where((tbl) => tbl.id.equals(taskId)))
        .watchSingle();
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
      await into(taskCategories).insert(TaskCategoriesCompanion.insert(
          sortType: SortTypes.byMarked,
          name: "Избранное",
          isDeletable: const Value(false)));
      await into(taskCategories).insert(TaskCategoriesCompanion.insert(
          name: "Мои задачи",
          isDeletable: const Value(false),
          sortType: SortTypes.byOwn));
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
