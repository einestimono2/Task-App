part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class LoadTasks extends TaskEvent {}

class UpdateTasks extends TaskEvent {
  final List<Task> tasks;

  UpdateTasks(this.tasks);

  @override
  List<Object> get props => [tasks];
}

class AddTask extends TaskEvent {
  final Task task;

  const AddTask({required this.task});

  @override
  List<Object> get props => [task];
}

class UpdateTask extends TaskEvent {
  final Task task;

  const UpdateTask({required this.task});

  @override
  List<Object> get props => [task];
}

class DeleteTask extends TaskEvent {
  final Task task;

  const DeleteTask({required this.task});

  @override
  List<Object> get props => [task];
}

class deleteAllTasksInTrash extends TaskEvent {}

class restoreAllTasksInTrash extends TaskEvent {}
