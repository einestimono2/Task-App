import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:tasks_app/blocs/blocs.dart';
import 'package:tasks_app/config/app_size.dart';
import 'package:tasks_app/models/models.dart';
import 'package:tasks_app/repositories/repositories.dart';
import 'package:tasks_app/widgets/widgets.dart';

class TaskDetailsScreen extends StatefulWidget {
  static const String routeName = "/task-details";
  static Route route({required String id}) => MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => TaskDetailsScreen(id: id),
      );

  const TaskDetailsScreen({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  final TaskRepository taskRepository = TaskRepository();

  @override
  void initState() {
    super.initState();

    BlocProvider.of<TaskDetailsBloc>(context).add(
      getTaskDetails(id: widget.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Task #${widget.id}',
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocBuilder<TaskDetailsBloc, TaskDetailsState>(
          builder: (context, state) {
            if (state is TaskDetailsLoading || state is TaskDetailsInitial) {
              return CircleLoading();
            } else if (state is TaskDetailsError) {
              return DisplayNotification(title: state.message, size: 22);
            } else if (state is TaskDetailsLoaded) {
              final Task task = state.task;

              // Delete Scheduled Notification of this task
              RepositoryProvider.of<NotificationRepository>(context)
                  .deleteScheduledNotification(task: task);

              return ListView.builder(
                itemCount: 2,
                itemBuilder: (context, index) => Container(
                  child: Row(
                    children: <Widget>[
                      SizedBox(width: 50),
                      Column(
                        children: <Widget>[
                          Container(
                            width:
                                getProportionateScreenWidth(index == 1 ? 5 : 1),
                            height: AppSize.screenHeight / 5,
                            color: index == 1
                                ? Colors.green
                                : Theme.of(context).textTheme.headline1!.color,
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: index == 0 ? Colors.green : Colors.red,
                            ),
                            child: Text(
                              index == 0 ? task.starts : task.ends,
                              style: Theme.of(context).textTheme.headline5!,
                            ),
                          ),
                          Container(
                            width:
                                getProportionateScreenWidth(index == 0 ? 5 : 1),
                            height: AppSize.screenHeight / 5,
                            color: index == 0
                                ? Colors.green
                                : Theme.of(context).textTheme.headline1!.color,
                          ),
                        ],
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: index == 0
                            ? SingleChildScrollView(
                                child: ListTile(
                                  title: Text(
                                    task.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline1!
                                        .copyWith(color: Colors.green),
                                    maxLines: 1,
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        '${Jiffy(task.date, 'M/d/y').yMd},  ${task.starts} - ${task.ends}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        task.notes,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4!
                                            .copyWith(
                                              fontWeight: FontWeight.normal,
                                            ),
                                      ),
                                    ],
                                  ),
                                  isThreeLine: true,
                                ),
                              )
                            : SizedBox(
                                child: Text(
                                  'Task End!',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1!
                                      .copyWith(color: Colors.red),
                                ),
                              ),
                      ),
                      SizedBox(width: 20),
                    ],
                  ),
                ),
              );
            } else {
              return DisplayNotification(
                  title: 'Something Went Wrong. Try later !', size: 22);
            }
          },
        ),
      ),
    );
  }
}
