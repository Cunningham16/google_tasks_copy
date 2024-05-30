import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_tasks/data/entities/task_category/task_category.dart';
import 'package:google_tasks/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final FirebaseFirestore _instance = FirebaseFirestore.instance;

  @override
  Future<void> deleteCategory(String id) async {
    await _instance.collection("/categories").doc(id).delete();
  }

  @override
  Future<void> saveCategory(TaskCategory taskCategory) async {
    await _instance.runTransaction((transaction) async {
      await _instance.collection("/categories").add(taskCategory.toJson());
    });
  }

  @override
  Future<void> updateCategory(String id, TaskCategory modifiedCategory) async {
    final updateDocRef = _instance.collection("/categories").doc(id);
    await _instance.runTransaction((transaction) async {
      transaction.update(updateDocRef, modifiedCategory.toJson());
    });
  }

  @override
  Stream<List<TaskCategory>> watchCategories(String userId) {
    return _instance
        .collection("/categories")
        .where("userId", isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final category = doc.data();
        return TaskCategory.fromJson(category);
      }).toList();
    });
  }
}
