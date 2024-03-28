import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:google_tasks/data/database/database.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category.entity.g.dart';

@immutable
@JsonSerializable()
class CategoryEntity extends Equatable {
  final int id;
  final String name;
  final bool isDeleteable;
  final int sortType;

  const CategoryEntity(
      {required this.id,
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
        id: Value(id),
        name: Value(name),
        sortType: Value(sortType),
        isDeletable: Value(isDeleteable));
  }

  Future<void> save(CategoryEntity categoryEntity) async {
    AppDatabase instance = AppDatabase();
    await instance
        .into(instance.taskCategories)
        .insertOnConflictUpdate(categoryEntity.toCompanion());
  }

  Future<void> update(int id, CategoryEntity newCategory) async {
    AppDatabase instance = AppDatabase();
    await (instance.update(instance.taskCategories)
          ..where((tbl) => tbl.id.equals(id)))
        .write(newCategory.toCompanion());
  }

  Future<void> delete(int id) async {
    AppDatabase instance = AppDatabase();
    await (instance.delete(instance.taskCategories)
          ..where((tbl) => tbl.id.equals(id) | tbl.isDeletable.isValue(true)))
        .go();
    await (instance.delete(instance.taskItems)
          ..where((tbl) => tbl.category.equals(id)))
        .go();
  }

  Stream<List<CategoryEntity>> queryCategories() {
    AppDatabase instance = AppDatabase();
    return (instance.select(instance.taskCategories)).watch();
  }

  factory CategoryEntity.fromJson(Map<String, dynamic> json) =>
      _$CategoryEntityFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryEntityToJson(this);

  @override
  List<Object> get props => [id, name, isDeleteable, sortType];
}
