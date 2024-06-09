import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_tasks/data/entities/task_item/task_item.dart';
import 'package:google_tasks/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final FirebaseFirestore _instanceStore = FirebaseFirestore.instance;
  final FirebaseAuth _instanceAuth = FirebaseAuth.instance;

  @override
  Future<void> deleteTask(String id) async {
    await _instanceStore.collection("/tasks").doc(id).delete();
  }

  @override
  Future<void> saveTask(TaskItem taskItem) async {
    await _instanceStore.collection("/tasks").add(taskItem.toJson());
  }

  @override
  Future<void> deleteAllCompletedTasks(String categoryId) async {
    final batch = _instanceStore.batch();
    final collection = await _instanceStore
        .collection("/tasks")
        .where(Filter.and(
            Filter("userId", isEqualTo: _instanceAuth.currentUser!.uid),
            Filter("category", isEqualTo: categoryId),
            Filter("isCompleted", isEqualTo: true)))
        .get();

    for (final doc in collection.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  @override
  Future<void> updateTask(String id, TaskItem taskItem) async {
    final updateDocRef = _instanceStore.collection("/tasks").doc(id);
    await _instanceStore.runTransaction((transaction) async {
      transaction.update(updateDocRef, taskItem.toJson());
    });
  }

  @override
  Future<TaskItem> getSingleTask(String id) async {
    return _instanceStore.collection("/tasks").doc(id).get().then(
        (value) => TaskItem.fromJson(value.data() as Map<String, Object?>));
  }

  @override
  Stream<List<TaskItem>> watchAllTasks() {
    return _instanceStore
        .collection("/tasks")
        .where("userId", isEqualTo: _instanceAuth.currentUser!.uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final task = doc.data();
        return TaskItem.fromJson(task);
      }).toList();
    });
  }

  @override
  Future<void> deleteTasksByCategory(String categoryId) async {
    final batch = _instanceStore.batch();
    final collection = await _instanceStore
        .collection("/tasks")
        .where(Filter.and(
          Filter("userId", isEqualTo: _instanceAuth.currentUser!.uid),
          Filter("category", isEqualTo: categoryId),
        ))
        .get();
    for (final doc in collection.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
