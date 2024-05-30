// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskItemImpl _$$TaskItemImplFromJson(Map<String, dynamic> json) =>
    _$TaskItemImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      content: json['content'] as String?,
      category: json['category'] as String,
      isCompleted: json['isCompleted'] as bool,
      isFavorite: json['isFavorite'] as bool,
      date: _$JsonConverterFromJson<Timestamp, DateTime>(
          json['date'], const TimestampConverter().fromJson),
      whenMarked: _$JsonConverterFromJson<Timestamp, DateTime>(
          json['whenMarked'], const TimestampConverter().fromJson),
      position: (json['position'] as num).toInt(),
    );

Map<String, dynamic> _$$TaskItemImplToJson(_$TaskItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'content': instance.content,
      'category': instance.category,
      'isCompleted': instance.isCompleted,
      'isFavorite': instance.isFavorite,
      'date': _$JsonConverterToJson<Timestamp, DateTime>(
          instance.date, const TimestampConverter().toJson),
      'whenMarked': _$JsonConverterToJson<Timestamp, DateTime>(
          instance.whenMarked, const TimestampConverter().toJson),
      'position': instance.position,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
