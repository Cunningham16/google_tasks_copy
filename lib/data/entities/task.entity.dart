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
      this.id,
      this.isFavorite = false,
      this.content = '',
      required this.title,
      this.date = '',
      this.time = ''});

  final int? id;
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
        id: Value(id ?? -1),
        title: Value(title),
        content: Value(content),
        category: Value(categoryId),
        isCompleted: Value(isCompleted),
        isFavorite: Value(isFavorite),
        date: Value(date),
        time: Value(time));
  }

  factory TaskEntity.fromJson(Map<String, dynamic> json) =>
      _$TaskEntityFromJson(json);

  Map<String, dynamic> toJson() => _$TaskEntityToJson(this);

  @override
  List<Object> get props =>
      [title, content, date, time, categoryId, isCompleted, isFavorite];
}
