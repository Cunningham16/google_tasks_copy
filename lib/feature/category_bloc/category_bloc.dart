import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_tasks/data/entities/category.entity.dart';
import 'package:google_tasks/domain/category.repository.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc({required CategoryRepository categoryRepository})
      : _categoryRepository = categoryRepository,
        super(const CategoryState()) {
    on<CategoryCreateRequest>(_onCategoryCreateRequest);
    on<CategoryDeleteRequest>(_onCategoryDeleteRequest);
    on<CategorySubscribeRequest>(_onCategorySubscribeRequest);
    on<CategoryUpdateRequest>(_onCategoryUpdateRequest);
  }

  final CategoryRepository _categoryRepository;

  Future<void> _onCategoryCreateRequest(
      CategoryCreateRequest event, Emitter<CategoryState> emit) async {
    await _categoryRepository.saveCategory(event.category);
  }

  Future<void> _onCategoryDeleteRequest(
      CategoryDeleteRequest event, Emitter<CategoryState> emit) async {
    await _categoryRepository.deleteCategory(event.id);
  }

  Future<void> _onCategorySubscribeRequest(
      CategorySubscribeRequest event, Emitter<CategoryState> emit) async {
    emit(state.copyWith(status: () => CategoryStatus.loading));

    await emit.forEach(_categoryRepository.getCategories(),
        onData: (categories) => state.copyWith(
            status: () => CategoryStatus.success,
            categoryList: () => categories),
        onError: (_, __) =>
            state.copyWith(status: () => CategoryStatus.failure));
  }

  Future<void> _onCategoryUpdateRequest(
      CategoryUpdateRequest event, Emitter<CategoryState> emit) async {
    await _categoryRepository.updateCategory(event.id, event.categoryEntity);
  }
}
