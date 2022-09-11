import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tasks_app/blocs/blocs.dart';
import 'package:tasks_app/models/models.dart';
import 'package:tasks_app/screens/screens.dart';
import 'package:tasks_app/utils/utils.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({Key? key, required this.task}) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: UniqueKey(),
      endActionPane: ActionPane(
        extentRatio: 0.25,
        motion: const DrawerMotion(),
        children: [
          Expanded(
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor:
                    Theme.of(context).primaryColor.withOpacity(0.4),
                shape: CircleBorder(
                  side: BorderSide(
                    width: 15,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
              ),
              onPressed: () => _deleteTask(context, task),
              child: Icon(
                Icons.delete_rounded,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
      child: _buildTaskCard(context),
    );
  }

  _buildTaskCard(BuildContext context) {
    final Map<String, String> alertMap = {
      '-1': 'None',
      '0': 'At time of task',
      '5': '5 minutes before',
      '10': '10 minutes before',
      '15': '15 minutes before',
      '30': '30 minutes before',
      '60': '60 minutes before',
    };

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          stops: [0.02, 0.025],
          colors: [
            task.isCompleted
                ? HexColor(task.color).withOpacity(0.5)
                : HexColor(task.color),
            Colors.white
          ],
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
        border: Border.all(
          color: HexColor(task.color).withOpacity(0.3),
          width: 1,
          style: BorderStyle.solid,
        ),
        boxShadow: [
          BoxShadow(
            color: HexColor(task.color).withOpacity(0.3),
            spreadRadius: 3.0,
            blurRadius: 3.0,
            offset: Offset(0, 0), // changes position of shadow
          ),
        ],
      ),
      child: ListTileTheme(
        horizontalTitleGap: 1.0,
        child: ExpansionTile(
          backgroundColor: HexColor(task.color).withOpacity(0.25),
          collapsedBackgroundColor: HexColor(task.color).withOpacity(0.08),
          maintainState: true,
          tilePadding: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
          title: Text(
            task.title,
            maxLines: 1,
            style: Theme.of(context).textTheme.headline3!.copyWith(
                  color: task.isCompleted ? Colors.grey : Colors.black,
                  decoration: task.isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
          ),
          subtitle: Text(
            textAlign: TextAlign.start,
            task.starts + " - " + task.ends,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: task.isCompleted ? Colors.grey : Colors.black87,
                  decoration: task.isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
          ),
          leading: Checkbox(
            checkColor: Colors.white,
            activeColor: Colors.green,
            value: task.isCompleted,
            shape: CircleBorder(),
            side: BorderSide(
              color: Colors.grey,
              width: 1,
            ),
            onChanged: (bool? value) =>
                task.isRemoved ? null : _updateTask(context, task),
          ),
          trailing: PopupMenuButton(
            enabled: !(task.isCompleted || task.isRemoved),
            color: Theme.of(context).scaffoldBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            itemBuilder: (context) => alertMap.keys
                .map<PopupMenuItem>(
                  (e) => PopupMenuItem(
                    onTap: () =>
                        _updateNotification(context, task, int.parse(e)),
                    child: Text(
                      alertMap[e]!,
                      style: TextStyle(
                        color: task.alert == int.parse(e)
                            ? Colors.red
                            : Theme.of(context).textTheme.headline1!.color,
                        fontWeight: task.alert == int.parse(e)
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                )
                .toList(),
            child: Container(
              padding: EdgeInsets.only(right: 13),
              child: Icon(
                task.alert == -1
                    ? Icons.notifications_off_outlined
                    : Icons.notifications_on_outlined,
                color: task.isCompleted
                    ? Colors.grey.withOpacity(0.7)
                    : Colors.black,
                size: 22,
              ),
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.only(
                right: 50,
                left: 50,
                bottom: 15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Divider(thickness: 1),
                  SizedBox(height: 10),
                  _customRow(context, "Notes", task.notes),
                  SizedBox(height: 10),
                  _customRow(
                    context,
                    "Alert",
                    alertMap[task.alert.toString()]!,
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      task.isCompleted
                          ? task.isRemoved
                              ? Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.green[300],
                                    ),
                                    onPressed: () =>
                                        _restoreTask(context, task),
                                    child: Icon(Icons.restore_outlined),
                                  ),
                                )
                              : SizedBox.shrink()
                          : task.isRemoved
                              ? Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.green[300],
                                    ),
                                    onPressed: () =>
                                        _restoreTask(context, task),
                                    child: Icon(Icons.restore_outlined),
                                  ),
                                )
                              : Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.green[300],
                                    ),
                                    onPressed: () => showModalBottomSheet(
                                      backgroundColor: Colors.transparent,
                                      isScrollControlled: true,
                                      context: context,
                                      builder: (context) => EditTaskScreen(
                                        task: task,
                                      ),
                                    ),
                                    child: Icon(Icons.edit_note_outlined),
                                  ),
                                ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red[400],
                          ),
                          onPressed: () => _deleteTask(context, task),
                          child: Icon(Icons.delete_outline_rounded),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _customRow(BuildContext context, String title, String note) {
    return Row(
      children: [
        Text(
          '• ${title}: \t',
          style: Theme.of(context)
              .textTheme
              .headline5!
              .copyWith(color: task.isCompleted ? Colors.grey : Colors.black87),
        ),
        Expanded(
          child: Text(
            note + ".",
            style: Theme.of(context).textTheme.headline6!.copyWith(
                color: task.isCompleted ? Colors.grey : Colors.black87),
          ),
        ),
      ],
    );
  }

  void _deleteTask(BuildContext context, Task task) {
    BlocProvider.of<TaskBloc>(context).add(DeleteTask(task: task));

    showSnackBar(
        context, task.isRemoved ? 'Deleted the task!' : 'Removed the task!');
  }

  void _restoreTask(BuildContext context, Task task) {
    BlocProvider.of<TaskBloc>(context)
        .add(UpdateTask(task: task.copyWith(isRemoved: !task.isRemoved)));

    showSnackBar(context, 'Restored the task!');
  }

  void _updateTask(BuildContext context, Task task) {
    BlocProvider.of<TaskBloc>(context)
        .add(UpdateTask(task: task.copyWith(isCompleted: !task.isCompleted)));

    showSnackBar(context, 'Changed the task!');
  }

  void _updateNotification(BuildContext context, Task task, int alert) {
    if (task.alert == alert) return;

    BlocProvider.of<TaskBloc>(context)
        .add(UpdateTask(task: task.copyWith(alert: alert)));

    showSnackBar(context, 'Updated task notification!');
  }
}
