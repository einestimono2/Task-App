import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:tasks_app/blocs/blocs.dart';
import 'package:tasks_app/config/app_size.dart';
import 'package:tasks_app/models/models.dart';
import 'package:tasks_app/utils/utils.dart';
import 'package:tasks_app/widgets/widgets.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  void initState() {
    super.initState();

    BlocProvider.of<TaskFilterBloc>(context).add(
      UpdateTaskFilter(taskFilter: TaskFilter.removed),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: getProportionateScreenHeight(5),
          horizontal: getProportionateScreenWidth(25),
        ),
        child: Column(
          children: [
            Expanded(
              child: BlocConsumer<TaskFilterBloc, TaskFilterState>(
                listenWhen: (previous, current) {
                  return current is TaskFilterLoaded &&
                      current.taskFilter == TaskFilter.removed;
                },
                listener: (context, state) {
                  if (state is TaskFilterLoaded) {
                    showSnackBar(
                      context,
                      'There are ${state.filteredTasks.length} task(s) in the trash.',
                    );
                  }
                },
                builder: (context, state) {
                  if (state is TaskFilterLoading ||
                      state is TaskFilterInitial) {
                    return CircleLoading();
                  } else if (state is TaskFilterLoaded) {
                    if (state.filteredTasks.length == 0) {
                      return DisplayNotification(
                        title: 'No Removed Tasks.',
                        size: 32,
                      );
                    } else {
                      return ListView.separated(
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 20),
                          itemCount: state.filteredTasks.length,
                          itemBuilder: (context, index) {
                            Task task = state.filteredTasks[index];

                            bool containHeader = index == 0 ||
                                task.date !=
                                    state.filteredTasks[index - 1].date;

                            if (containHeader) {
                              return Column(
                                children: [
                                  index == 0
                                      ? SizedBox()
                                      : SizedBox(height: 30),
                                  Center(
                                    child: Chip(
                                      backgroundColor: Colors.blue.shade300,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          color: Colors.white70,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      avatar: Text(
                                        Jiffy(task.date, 'M/d/y').E,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                              color: Colors.white70,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      label: Text(
                                        task.date,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5!
                                            .copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  TaskCard(task: task),
                                ],
                              );
                            } else {
                              return TaskCard(task: task);
                            }
                          });
                    }
                  } else {
                    return DisplayNotification(
                      title: 'Something Went Wrong. Try later',
                      size: 18,
                    );
                  }
                },
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
          ],
        ),
      ),
    );
  }
}
