import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tasks_app/blocs/blocs.dart';
import 'package:tasks_app/models/models.dart';

part 'task_filter_event.dart';
part 'task_filter_state.dart';

class TaskFilterBloc extends Bloc<TaskFilterEvent, TaskFilterState> {
  final TaskBloc _taskBloc;
  late StreamSubscription _taskSubscription;

  TaskFilterBloc({required TaskBloc taskBloc})
      : _taskBloc = taskBloc,
        super(TaskFilterInitial()) {
    on<UpdateTaskFilter>(_onUpdateTaskFilter);

    _taskSubscription = _taskBloc.stream.listen((state) {
      if (state is TaskLoaded) {
        if (this.state is TaskFilterLoaded) {
          add(
            UpdateTaskFilter(
              taskFilter: (this.state as TaskFilterLoaded).taskFilter,
            ),
          );
        } else {
          add(
            UpdateTaskFilter(),
          );
        }
      }
    });
  }

  void _onUpdateTaskFilter(
    UpdateTaskFilter event,
    Emitter<TaskFilterState> emit,
  ) {
    final state = _taskBloc.state;

    if (state is TaskLoaded) {
      emit(TaskFilterLoading());

      List<Task> filteredTasks = state.tasks.where((task) {
        switch (event.taskFilter) {
          case TaskFilter.all:
            return true;
          case TaskFilter.completed:
            return task.isCompleted;
          case TaskFilter.removed:
            return task.isRemoved;
          case TaskFilter.pending:
            return !(task.isRemoved || task.isCompleted);
        }
      }).toList();

      emit(
        TaskFilterLoaded(
          filteredTasks: filteredTasks,
          taskFilter: event.taskFilter,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _taskSubscription.cancel();
    return super.close();
  }
}
