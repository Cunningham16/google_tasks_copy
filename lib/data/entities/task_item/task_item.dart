import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_item.freezed.dart';
part 'task_item.g.dart';

class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp timestamp) {
    return timestamp.toDate();
  }

  @override
  Timestamp toJson(DateTime date) => Timestamp.fromDate(date);
}

@freezed
class TaskItem with _$TaskItem {
  const factory TaskItem(
      {required String id,
      required String userId,
      required String title,
      String? content,
      required int category,
      required bool isCompleted,
      required bool isFavorite,
      @TimestampConverter() DateTime? date,
      @TimestampConverter() DateTime? whenMarked,
      required int position}) = _TaskItem;

  factory TaskItem.fromJson(Map<String, Object?> json) =>
      _$TaskItemFromJson(json);
}
