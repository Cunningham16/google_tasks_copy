import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_tasks/data/entities/category.entity.dart';
import 'package:google_tasks/data/entities/task.entity.dart';
import 'package:google_tasks/domain/task.repository.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc({required TaskRepository taskRepository})
      : _taskRepository = taskRepository,
        super(const TaskState()) {
    on<TaskSubscriptionRequested>(_onSubcriptionRequested);
    on<TaskCompletionToggled>(_onTaskCompletionToggled);
    on<TaskDeletionRequest>(_onTaskDeletionRequest);
    on<TaskUpdateRequest>(_onTaskUpdateRequest);
    on<TaskCreateRequest>(_onTaskCreateRequest);
    on<CategoryCreateRequest>(_onCategoryCreateRequest);
    on<CategoryDeleteRequest>(_onCategoryDeleteRequest);
    on<CategorySubscribeRequest>(_onCategorySubscribeRequest);
    on<CategoryUpdateRequest>(_onCategoryUpdateRequest);
    //on<CategoryGetRequest>(_onCategoryGetRequest);
  }

  final TaskRepository _taskRepository;

  Future<void> _onSubcriptionRequested(
      TaskSubscriptionRequested event, Emitter<TaskState> emit) async {
    emit(state.copyWith(status: TasksStatus.loading));

    await emit.forEach(_taskRepository.getAllTasks(),
        onData: (tasksList) =>
            state.copyWith(status: TasksStatus.success, taskList: tasksList),
        onError: (_, __) => state.copyWith(
              status: TasksStatus.failure,
            ));
  }

  Future<void> _onTaskCompletionToggled(
      TaskCompletionToggled event, Emitter<TaskState> emit) async {
    final newTask = event.task.copyWith(isCompleted: event.isCompleted);
    await _taskRepository.updateTask(newTask.id as int, newTask);
  }

  Future<void> _onTaskDeletionRequest(
      TaskDeletionRequest event, Emitter<TaskState> emit) async {
    await _taskRepository.deleteTask(event.id);
  }

  Future<void> _onTaskUpdateRequest(
      TaskUpdateRequest event, Emitter<TaskState> emit) async {
    await _taskRepository.updateTask(event.id, event.task);
  }

  Future<void> _onTaskCreateRequest(
      TaskCreateRequest event, Emitter<TaskState> emit) async {
    await _taskRepository.saveTask(event.task);
  }

  Future<void> _onCategoryCreateRequest(
      CategoryCreateRequest event, Emitter<TaskState> emit) async {
    await _taskRepository.saveCategory(event.category);
  }

  Future<void> _onCategoryDeleteRequest(
      CategoryDeleteRequest event, Emitter<TaskState> emit) async {
    await _taskRepository.deleteCategory(event.id);
  }

  Future<void> _onCategorySubscribeRequest(
      CategorySubscribeRequest event, Emitter<TaskState> emit) async {
    emit(state.copyWith(categoryList: _taskRepository.watchCategories()));
    //await emit.forEach(_taskRepository.watchCategories(), onData: (categories) {
    //  return TaskState(
    //      categoryList: categories,
    //      taskList: state.taskList,
    //      status: state.status);
    //}, onError: (_, __) {
    //  print("error!!");
    //  throw UnimplementedError();
    //});
  }

  Future<void> _onCategoryUpdateRequest(
      CategoryUpdateRequest event, Emitter<TaskState> emit) async {
    await _taskRepository.updateCategory(event.id, event.categoryEntity);
  }

  //Future<void> _onCategoryGetRequest(
  //    CategoryGetRequest event, Emitter<TaskState> emit) async {
  //  List<CategoryEntity> categories = await _taskRepository.getCategories();
  //  emit(state.copyWith(categoryList: categories));
  //}
}
