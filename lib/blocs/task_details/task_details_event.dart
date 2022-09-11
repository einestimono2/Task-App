part of 'task_details_bloc.dart';

abstract class TaskDetailsEvent extends Equatable {
  const TaskDetailsEvent();

  @override
  List<Object> get props => [];
}

class getTaskDetails extends TaskDetailsEvent {
  final String id;

  const getTaskDetails({required this.id});

  List<Object> get props => [id];
}
