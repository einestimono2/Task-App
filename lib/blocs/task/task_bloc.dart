import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tasks_app/models/models.dart';
import 'package:tasks_app/repositories/repositories.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskRepository _taskRepository;
  NotificationRepository _notificationRepository;
  StreamSubscription? _taskSubscription;

  TaskBloc({
    required TaskRepository taskRepository,
    required NotificationRepository notificationRepository,
  })  : _taskRepository = taskRepository,
        _notificationRepository = notificationRepository,
        super(TaskInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<UpdateTasks>(_onUpdateTasks);
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<deleteAllTasksInTrash>(_onDeleteAllTasksInTrash);
    on<restoreAllTasksInTrash>(_onRestoreAllTasksInTrash);
  }

  FutureOr<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) {
    try {
      emit(TaskLoading());
      //
      _taskSubscription?.cancel();
      _taskSubscription = _taskRepository.getAllTasks().listen(
            (tasks) => add(
              UpdateTasks(tasks),
            ),
          );
    } catch (e) {
      emit(TaskError(message: e.toString()));
    }
  }

  FutureOr<void> _onUpdateTasks(UpdateTasks event, Emitter<TaskState> emit) {
    emit(TaskLoaded(tasks: event.tasks));
  }

  FutureOr<void> _onAddTask(AddTask event, Emitter<TaskState> emit) async {
    try {
      final state = this.state;

      if (state is TaskLoaded) {
        emit(TaskLoading());

        Task task = await _taskRepository.addTask(event.task);

        if (task.alert != -1) {
          await _notificationRepository.addScheduledNotification(task: task);
        }

        emit(
          TaskLoaded(
            tasks: List.from(state.tasks)..add(task),
          ),
        );
      }
    } catch (e) {
      emit(TaskError(message: e.toString()));
    }
  }

  FutureOr<void> _onUpdateTask(
    UpdateTask event,
    Emitter<TaskState> emit,
  ) async {
    try {
      final state = this.state;

      if (state is TaskLoaded) {
        emit(TaskLoading());

        await _taskRepository.updateTask(event.task);

        int index = state.tasks.indexWhere(
          (element) => element.id == event.task.id,
        );

        // Restore or change status to pending ==> update notification
        if ((state.tasks[index].isRemoved == true &&
                event.task.isRemoved == false) ||
            (state.tasks[index].isCompleted == true &&
                event.task.isCompleted == false)) {
          await _notificationRepository.addScheduledNotification(
              task: event.task);
        }

        // Completed ==> delete notification
        if (state.tasks[index].isCompleted == false &&
            event.task.isCompleted == true) {
          await _notificationRepository.deleteScheduledNotification(
              task: event.task);
        }

        // Update time notification
        if (state.tasks[index].alert != event.task.alert ||
            state.tasks[index].starts != event.task.starts) {
          if (event.task.alert == -1)
            await _notificationRepository.deleteScheduledNotification(
                task: event.task);
          else
            await _notificationRepository.addScheduledNotification(
                task: event.task);
        }

        state.tasks[index] = event.task;

        emit(TaskLoaded(tasks: state.tasks));
      }
    } catch (e) {
      emit(TaskError(message: e.toString()));
    }
  }

  void _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    try {
      final state = this.state;

      if (state is TaskLoaded) {
        emit(TaskLoading());
        //
        await _taskRepository.deleteTask(event.task);
        //
        await _notificationRepository.deleteScheduledNotification(
            task: event.task);
        //
        List<Task> tasks;
        if (event.task.isRemoved) {
          tasks = (state.tasks.where((task) {
            return task.id != event.task.id;
          })).toList();
        } else {
          tasks = (state.tasks.map((task) {
            return task.id == event.task.id
                ? task.copyWith(isRemoved: true)
                : task;
          })).toList();
        }

        emit(TaskLoaded(tasks: tasks));
      }
    } catch (e) {
      emit(TaskError(message: e.toString()));
    }
  }

  FutureOr<void> _onDeleteAllTasksInTrash(
    deleteAllTasksInTrash event,
    Emitter<TaskState> emit,
  ) async {
    try {
      final state = this.state;

      if (state is TaskLoaded) {
        emit(TaskLoading());

        await _taskRepository.deleteAllTasksInTrash();

        List<Task> tasks = state.tasks.where((task) {
          return task.isRemoved != true;
        }).toList();

        emit(TaskLoaded(tasks: tasks));
      }
    } catch (e) {
      emit(TaskError(message: e.toString()));
    }
  }

  FutureOr<void> _onRestoreAllTasksInTrash(
    restoreAllTasksInTrash event,
    Emitter<TaskState> emit,
  ) async {
    try {
      final state = this.state;

      if (state is TaskLoaded) {
        emit(TaskLoading());

        await _taskRepository.restoreAllTasksInTrash();

        List<Task> tasks = state.tasks.map((task) {
          return task.isRemoved ? task.copyWith(isRemoved: false) : task;
        }).toList();

        emit(TaskLoaded(tasks: tasks));
      }
    } catch (e) {
      emit(TaskError(message: e.toString()));
    }
  }
}
