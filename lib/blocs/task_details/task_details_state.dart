part of 'task_details_bloc.dart';

abstract class TaskDetailsState extends Equatable {
  const TaskDetailsState();

  @override
  List<Object> get props => [];
}

class TaskDetailsInitial extends TaskDetailsState {}

class TaskDetailsLoading extends TaskDetailsState {}

class TaskDetailsLoaded extends TaskDetailsState {
  final Task task;

  const TaskDetailsLoaded({
    required this.task,
  });
  
  @override
  List<Object> get props => [task];
}

class TaskDetailsError extends TaskDetailsState {
  final String message;

  const TaskDetailsError({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
