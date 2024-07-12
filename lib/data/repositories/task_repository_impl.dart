import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_tasks/data/entities/task_item/task_item.dart';
import 'package:google_tasks/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final FirebaseFirestore _instanceStore = FirebaseFirestore.instance;
  final FirebaseAuth _instanceAuth = FirebaseAuth.instance;

  @override
  Future<void> deleteTask(String id) async {
    final query = await _instanceStore
        .collection("/tasks")
        .where("id", isEqualTo: id)
        .get();
    await _instanceStore.collection("/tasks").doc(query.docs[0].id).delete();
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
    final updateDocRef = await _instanceStore
        .collection("/tasks")
        .where("id", isEqualTo: id)
        .get();
    await _instanceStore.runTransaction((transaction) async {
      transaction.update(updateDocRef.docs[0].reference, taskItem.toJson());
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

  // taskItem без изменений, оно само сделается
  @override
  Future<void> reorderListTasks(
      String categoryId, List<TaskItem> taskItems) async {
    final batch = _instanceStore.batch();
    final collection = await _instanceStore
        .collection("/tasks")
        .where(Filter.and(
          Filter("userId", isEqualTo: _instanceAuth.currentUser!.uid),
          Filter("category", isEqualTo: categoryId),
        ))
        .get();

    for (int i = 0; i < taskItems.length; i++) {
      batch.update(
          collection.docs
              .firstWhere((element) =>
                  TaskItem.fromJson(element.data()).id == taskItems[i].id)
              .reference,
          taskItems[i].copyWith(position: i).toJson());
    }

    batch.commit();
  }
}
