import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_tasks/data/database/database.dart';
import 'package:google_tasks/domain/repositories/task_repository.dart';
import 'package:google_tasks/utils/enums/sort_types.dart';

part "category_event.dart";
part "category_state.dart";

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc({required TaskRepository taskRepository})
      : _taskRepository = taskRepository,
        super(const CategoryState()) {
    on<CategorySubscriptionRequested>(_onCategorySubscriptionRequested);
    on<CategoryCreated>(_onCategoryCreated);
    on<CategoryRenamed>(_onCategoryRenamed);
    on<CategoryDeleted>(_onCategoryDeleted);
    on<CategoryChangedSort>(_onCategoryChangedSort);
  }

  final TaskRepository _taskRepository;

  Future<void> _onCategorySubscriptionRequested(
      CategorySubscriptionRequested event, Emitter<CategoryState> emit) async {
    emit(state.copyWith(categoryStatus: () => CategoryStatus.loading));

    await emit.forEach(_taskRepository.watchCategories(),
        onData: (data) => state.copyWith(
            categoryStatus: () => CategoryStatus.success,
            categoryList: () => data));
  }

  Future<void> _onCategoryCreated(
      CategoryCreated event, Emitter<CategoryState> emit) async {
    await _taskRepository.saveCategory(event.companion);
  }

  Future<void> _onCategoryRenamed(
      CategoryRenamed event, Emitter<CategoryState> emit) async {
    await _taskRepository.updateCategory(event.taskCategory.id,
        event.taskCategory.copyWith(name: event.newName).toCompanion(true));
  }

  Future<void> _onCategoryChangedSort(
      CategoryChangedSort event, Emitter<CategoryState> emit) async {
    await _taskRepository.updateCategory(
        event.taskCategory.id,
        event.taskCategory
            .copyWith(sortType: event.sortType)
            .toCompanion(true));
  }

  Future<void> _onCategoryDeleted(
      CategoryDeleted event, Emitter<CategoryState> emit) async {
    assert(event.taskCategory.isDeletable, "Категория не может быть удалена");
    await _taskRepository.deleteCategory(event.taskCategory.id);
  }
}
