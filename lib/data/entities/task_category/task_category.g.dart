// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskCategoryImpl _$$TaskCategoryImplFromJson(Map<String, dynamic> json) =>
    _$TaskCategoryImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      isDeleteable: json['isDeleteable'] as bool,
      sortType: $enumDecode(_$SortTypesEnumMap, json['sortType']),
    );

Map<String, dynamic> _$$TaskCategoryImplToJson(_$TaskCategoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'isDeleteable': instance.isDeleteable,
      'sortType': _$SortTypesEnumMap[instance.sortType]!,
    };

const _$SortTypesEnumMap = {
  SortTypes.byOwn: 'byOwn',
  SortTypes.byDate: 'byDate',
  SortTypes.byMarked: 'byMarked',
};
