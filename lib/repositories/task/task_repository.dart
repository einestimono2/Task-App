import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasks_app/models/task_model.dart';
import 'package:tasks_app/repositories/repositories.dart';

class TaskRepository extends BaseTaskRepository {
  final CollectionReference _taskCollection =
      FirebaseFirestore.instance.collection('tasks');

  final WriteBatch _taskBatch = FirebaseFirestore.instance.batch();

  @override
  Future<Task> addTask(Task task) async {
    final doc = _taskCollection.doc();
    task = task.copyWith(id: doc.id);
    await doc.set(task.toMap());

    return task;
  }

  @override
  Future<void> deleteTask(Task task) async {
    if (task.isRemoved) {
      final doc = _taskCollection.doc(task.id);
      await doc.delete();
    } else {
      await updateTask(task.copyWith(isRemoved: true));
    }
  }

  @override
  Stream<List<Task>> getAllTasks() => _taskCollection
      .orderBy(
        'date',
      )
      .orderBy(
        'starts',
      )
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map(
              (document) =>
                  Task.fromMap(document.data() as Map<String, dynamic>),
            )
            .toList(),
      );

  @override
  Future<void> updateTask(Task task) async {
    final doc = _taskCollection.doc(task.id);
    await doc.update(task.toMap());
  }

  @override
  Future<String> getOldestDate() async {
    final ref = await _taskCollection.orderBy('date').limit(1).get();

    if (ref.docs.length <= 0) return "";

    Task task = Task.fromMap(ref.docs[0].data() as Map<String, dynamic>);

    return task.date;
  }

  @override
  Future<void> deleteAllTasksInTrash() async {
    var snapshots =
        await _taskCollection.where('isRemoved', isEqualTo: true).get();

    for (var doc in snapshots.docs) {
      _taskBatch.delete(doc.reference);
    }

    await _taskBatch.commit();
  }

  @override
  Future<void> restoreAllTasksInTrash() async {
    var snapshots =
        await _taskCollection.where('isRemoved', isEqualTo: true).get();

    for (var doc in snapshots.docs) {
      _taskBatch.update(doc.reference, {'isRemoved': false});
    }

    await _taskBatch.commit();
  }

  @override
  Future<Task?> getTask(String id) async {
    final doc = await _taskCollection.doc(id).get();

    if (doc.data() == null)
      return null;
    else
      return Task.fromMap(doc.data() as Map<String, dynamic>);
  }
}
