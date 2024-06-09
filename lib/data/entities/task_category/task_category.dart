import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_tasks/utils/enums/sort_types.dart';

part 'task_category.freezed.dart';
part 'task_category.g.dart';

@freezed
class TaskCategory with _$TaskCategory {
  factory TaskCategory({
    required String id,
    required String userId,
    required String name,
    required bool isDeleteable,
    required SortTypes sortType,
    required bool isFavoriteFlag,
  }) = _TaskCategory;

  factory TaskCategory.fromJson(Map<String, dynamic> json) =>
      _$TaskCategoryFromJson(json);
}
