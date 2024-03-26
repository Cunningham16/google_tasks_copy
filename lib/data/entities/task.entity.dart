import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:google_tasks/data/database/database.dart';
import 'package:json_annotation/json_annotation.dart';

part 'task.entity.g.dart';

@immutable
@JsonSerializable()
class TaskEntity extends Equatable {
  const TaskEntity(
      {this.categoryId = 0,
      this.isCompleted = false,
      required this.id,
      this.isFavorite = false,
      this.content = '',
      required this.title,
      this.date = '',
      this.time = ''});

  final int id;
  final String title;
  final String content;
  final int categoryId;
  final String date;
  final String time;
  final bool isCompleted;
  final bool isFavorite;

  TaskEntity copyWith(
      {int? id,
      int? categoryId,
      String? title,
      String? content,
      String? date,
      String? time,
      bool? isCompleted,
      bool? isFavorite}) {
    return TaskEntity(
        id: id ?? this.id,
        title: title ?? this.title,
        content: content ?? this.content,
        date: date ?? this.date,
        time: time ?? this.time,
        isCompleted: isCompleted ?? this.isCompleted,
        isFavorite: isFavorite ?? this.isFavorite,
        categoryId: categoryId ?? this.categoryId);
  }

  TaskItemsCompanion toCompanion() {
    return TaskItemsCompanion(
        id: Value(id),
        title: Value(title),
        content: Value(content),
        category: Value(categoryId),
        isCompleted: Value(isCompleted),
        isFavorite: Value(isFavorite),
        date: Value(date),
        time: Value(time));
  }

  Future<void> save(TaskEntity entity) async {
    AppDatabase instance = AppDatabase();
    await instance
        .into(instance.taskItems)
        .insertOnConflictUpdate(entity.toCompanion());
  }

  Future<void> delele(int id) async {
    AppDatabase instance = AppDatabase();
    await (instance.delete(instance.taskItems)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
  }

  Future<void> update(int id, TaskEntity taskEntity) async {
    AppDatabase instance = AppDatabase();
    await (instance.update(instance.taskItems)
          ..where((tbl) => tbl.id.equals(id)))
        .write(taskEntity.toCompanion());
  }

  Future<List<TaskEntity>> queryTasksByCategory(int categoryId) async {
    AppDatabase instance = AppDatabase();
    return (instance.select(instance.taskItems)
          ..where((tbl) => tbl.category.equals(categoryId)))
        .get();
  }

  Future<TaskEntity?> querySingleTask(int taskId) async {
    AppDatabase instance = AppDatabase();
    return (instance.select(instance.taskItems)
          ..where((tbl) => tbl.id.equals(taskId)))
        .getSingleOrNull();
  }

  Future<List<TaskEntity>> queryTaskByFavorites() async {
    AppDatabase instance = AppDatabase();
    return (instance.select(instance.taskItems)
          ..where((tbl) => tbl.isFavorite.isValue(true)))
        .get();
  }

  factory TaskEntity.fromJson(Map<String, dynamic> json) =>
      _$TaskEntityFromJson(json);

  Map<String, dynamic> toJson() => _$TaskEntityToJson(this);

  @override
  List<Object> get props =>
      [id, title, content, date, time, categoryId, isCompleted, isFavorite];
}
