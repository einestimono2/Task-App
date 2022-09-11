part of 'task_filter_bloc.dart';

abstract class TaskFilterEvent extends Equatable {
  const TaskFilterEvent();

  @override
  List<Object> get props => [];
}

class UpdateTaskFilter extends TaskFilterEvent {
  final TaskFilter taskFilter;

  const UpdateTaskFilter({
    this.taskFilter = TaskFilter.all
  });

  @override
  List<Object> get props => [taskFilter];
}
