part of 'task_filter_bloc.dart';

abstract class TaskFilterState extends Equatable {
  const TaskFilterState();
  
  @override
  List<Object> get props => [];
}

class TaskFilterInitial extends TaskFilterState {}

class TaskFilterLoading extends TaskFilterState {}

class TaskFilterLoaded extends TaskFilterState {
  final List<Task> filteredTasks;
  final TaskFilter taskFilter;

  const TaskFilterLoaded({
    required this.filteredTasks,
    this.taskFilter = TaskFilter.all,
  });

  @override
  List<Object> get props => [filteredTasks, taskFilter];
}
