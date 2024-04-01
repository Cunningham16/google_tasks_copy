// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryEntity _$CategoryEntityFromJson(Map<String, dynamic> json) =>
    CategoryEntity(
      id: json['id'] as int?,
      name: json['name'] as String,
      sortType: json['sortType'] as int? ?? 0,
      isDeleteable: json['isDeleteable'] as bool? ?? true,
    );

Map<String, dynamic> _$CategoryEntityToJson(CategoryEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'isDeleteable': instance.isDeleteable,
      'sortType': instance.sortType,
    };
