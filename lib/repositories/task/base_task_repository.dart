import 'package:tasks_app/models/models.dart';

abstract class BaseTaskRepository {
  Stream<List<Task>> getAllTasks();
  Future<Task?> getTask(String id);
  Future<String> getOldestDate();
  Future<void> addTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(Task task);
  Future<void> deleteAllTasksInTrash();
  Future<void> restoreAllTasksInTrash();
}
