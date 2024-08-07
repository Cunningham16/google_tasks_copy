import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_tasks/data/entities/task_category/task_category.dart';
import 'package:google_tasks/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final FirebaseFirestore _instanceStore = FirebaseFirestore.instance;

  @override
  Future<void> deleteCategory(String id) async {
    final query = await _instanceStore
        .collection("/categories")
        .where("id", isEqualTo: id)
        .get();
    await _instanceStore
        .collection("/categories")
        .doc(query.docs[0].id)
        .delete();
  }

  @override
  Future<void> saveCategory(TaskCategory taskCategory) async {
    await _instanceStore.runTransaction((transaction) async {
      await _instanceStore.collection("/categories").add(taskCategory.toJson());
    });
  }

  @override
  Future<void> updateCategory(String id, TaskCategory modifiedCategory) async {
    final updateDocRef = await _instanceStore
        .collection("/categories")
        .where("id", isEqualTo: id)
        .get();
    await _instanceStore.runTransaction((transaction) async {
      transaction.update(
          updateDocRef.docs[0].reference, modifiedCategory.toJson());
    });
  }

  @override
  Stream<List<TaskCategory>> watchCategories() {
    return _instanceStore
        .collection("/categories")
        .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final category = doc.data();
        return TaskCategory.fromJson(category);
      }).toList()
        ..sort(((a, b) {
          if (b.isFavoriteFlag) {
            return 1;
          }
          return -1;
        }));
    });
  }
}
