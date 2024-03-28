import 'package:google_tasks/data/entities/category.entity.dart';

abstract class CategoryRepository {
  const CategoryRepository({
    required CategoryEntity categoryEntity,
  }) : _categoryEntity = categoryEntity;

  final CategoryEntity _categoryEntity;

  Future<void> saveCategory(CategoryEntity entity) =>
      _categoryEntity.save(entity);

  Future<void> updateCategory(id, newCategory) =>
      _categoryEntity.update(id, newCategory);

  Future<void> deleteCategory(int id) => _categoryEntity.delete(id);

  Stream<List<CategoryEntity>> getCategories() =>
      _categoryEntity.queryCategories();
}
