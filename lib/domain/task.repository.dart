import 'package:google_tasks/data/entities/task.entity.dart';

abstract class TaskRepository {
  const TaskRepository({
    required TaskEntity taskEntity,
  }) : _taskEntity = taskEntity;

  final TaskEntity _taskEntity;

  Future<void> deleteTask(int id) => _taskEntity.delele(id);

  Future<void> saveTask(TaskEntity entity) => _taskEntity.save(entity);

  Future<void> updateTask(int id, TaskEntity taskEntity) =>
      _taskEntity.update(id, taskEntity);

  Future<List<TaskEntity>> getTasksByCategory(int categoryId) =>
      _taskEntity.queryTasksByCategory(categoryId);

  Future<TaskEntity?> getSingleTask(int taskId) =>
      _taskEntity.querySingleTask(taskId);

  Future<List<TaskEntity>> getTasksByFavorites() =>
      _taskEntity.queryTaskByFavorites();

  Stream<List<TaskEntity>> getAllTasks() => _taskEntity.queryAllTasks();
}
