import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:google_tasks/data/database/database.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category.entity.g.dart';

@immutable
@JsonSerializable()
class CategoryEntity extends Equatable {
  final int? id;
  final String name;
  final bool isDeleteable;
  final int sortType;

  const CategoryEntity(
      {this.id,
      required this.name,
      this.sortType = 0,
      this.isDeleteable = true});

  CategoryEntity copyWith(
      int? id, String? name, bool? isDeleteable, int? sortType) {
    return CategoryEntity(
        id: id ?? this.id,
        name: name ?? this.name,
        isDeleteable: isDeleteable ?? this.isDeleteable,
        sortType: sortType ?? this.sortType);
  }

  TaskCategoriesCompanion toCompanion() {
    return TaskCategoriesCompanion(
        name: Value(name),
        sortType: Value(sortType),
        isDeletable: Value(isDeleteable));
  }

  factory CategoryEntity.fromJson(Map<String, dynamic> json) =>
      _$CategoryEntityFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryEntityToJson(this);

  @override
  List<Object> get props => [name, isDeleteable, sortType];
}
