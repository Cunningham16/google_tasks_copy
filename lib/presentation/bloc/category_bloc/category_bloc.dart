import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_tasks/data/entities/task_category/task_category.dart';
import 'package:google_tasks/domain/use_cases/delete_category_use_case.dart';
import 'package:google_tasks/domain/use_cases/save_category_use_case.dart';
import 'package:google_tasks/domain/use_cases/update_category_use_case.dart';
import 'package:google_tasks/domain/use_cases/watch_categories_use_case.dart';

part "category_event.dart";
part "category_state.dart";

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final SaveCategoryUseCase saveCategoryUseCase;
  final DeleteCategoryUseCase deleteCategoryUseCase;
  final WatchCategoriesUseCase watchCategoriesUseCase;
  final UpdateCategoryUseCase updateCategoryUseCase;

  CategoryBloc(
      {required this.deleteCategoryUseCase,
      required this.saveCategoryUseCase,
      required this.updateCategoryUseCase,
      required this.watchCategoriesUseCase})
      : super(const CategoryState()) {
    on<CategorySubscriptionRequested>(_onCategorySubscriptionRequested);
    on<CategoryCreated>(_onCategoryCreated);
    on<CategoryUpdated>(_onCategoryUpdated);
    on<CategoryDeleted>(_onCategoryDeleted);
  }

  Future<void> _onCategorySubscriptionRequested(
      CategorySubscriptionRequested event, Emitter<CategoryState> emit) async {
    emit(state.copyWith(categoryStatus: () => CategoryStatus.loading));

    await emit.forEach(watchCategoriesUseCase(),
        onData: (data) => state.copyWith(
            categoryStatus: () => CategoryStatus.success,
            categoryList: () => data));
  }

  Future<void> _onCategoryCreated(
      CategoryCreated event, Emitter<CategoryState> emit) async {
    await saveCategoryUseCase(params: event.params);
  }

  Future<void> _onCategoryUpdated(
      CategoryUpdated event, Emitter<CategoryState> emit) async {
    await updateCategoryUseCase(params: event.params);
  }

  Future<void> _onCategoryDeleted(
      CategoryDeleted event, Emitter<CategoryState> emit) async {
    assert(event.taskCategory.isDeleteable, "Категория не может быть удалена");
    await deleteCategoryUseCase(event.taskCategory.id);
  }
}
