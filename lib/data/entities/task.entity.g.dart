// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskEntity _$TaskEntityFromJson(Map<String, dynamic> json) => TaskEntity(
      categoryId: json['categoryId'] as int? ?? 0,
      isCompleted: json['isCompleted'] as bool? ?? false,
      id: json['id'] as int,
      isFavorite: json['isFavorite'] as bool? ?? false,
      content: json['content'] as String? ?? '',
      title: json['title'] as String,
      date: json['date'] as String? ?? '',
      time: json['time'] as String? ?? '',
    );

Map<String, dynamic> _$TaskEntityToJson(TaskEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'categoryId': instance.categoryId,
      'date': instance.date,
      'time': instance.time,
      'isCompleted': instance.isCompleted,
      'isFavorite': instance.isFavorite,
    };
