import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tasks_app/models/models.dart';
import 'package:tasks_app/repositories/repositories.dart';

part 'task_details_event.dart';
part 'task_details_state.dart';

class TaskDetailsBloc extends Bloc<TaskDetailsEvent, TaskDetailsState> {
  TaskRepository _taskRepository;

  TaskDetailsBloc({required TaskRepository taskRepository})
      : _taskRepository = taskRepository,
        super(TaskDetailsInitial()) {
    on<getTaskDetails>(_onGetTaskDetails);
  }

  FutureOr<void> _onGetTaskDetails(
    getTaskDetails event,
    Emitter<TaskDetailsState> emit,
  ) async {
    try {
      emit(TaskDetailsLoading());

      Task? task = await _taskRepository.getTask(event.id);

      if (task == null)
        emit(TaskDetailsError(message: 'Task not exist!'));
      else
        emit(TaskDetailsLoaded(task: task));
    } catch (e) {
      emit(TaskDetailsError(message: e.toString()));
    }
  }
}
