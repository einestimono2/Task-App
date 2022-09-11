import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:jiffy/jiffy.dart';
import 'package:tasks_app/blocs/blocs.dart';
import 'package:tasks_app/models/models.dart';
import 'package:tasks_app/screens/screens.dart';
import 'package:tasks_app/widgets/widgets.dart';

import '../../config/app_size.dart';
import '../../repositories/repositories.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AppTheme _curTheme;
  late TaskFilter _taskFilter;

  DatePickerController _dateController = DatePickerController();

  DateTime _oldestDate = DateTime.now();
  DateTime _selectedDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  void getOldestDate() async {
    await RepositoryProvider.of<TaskRepository>(context).getOldestDate().then(
          (date) => setState(
            () => _oldestDate = Jiffy(date, 'M/d/y').dateTime,
          ),
        );

    // Run method on widget build complete ==> Use WidgetsBinding or SchedulerBinding
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _dateController.animateToSelection(),
    );
  }

  @override
  void initState() {
    super.initState();
    _curTheme = AppTheme.darkTheme;

    _taskFilter = TaskFilter.all;
    // BlocProvider.of<TaskFilterBloc>(context).add(
    //   UpdateTaskFilter(taskFilter: _taskFilter),
    // );

    _controller = BottomSheet.createAnimationController(this);
    _controller.duration = const Duration(milliseconds: 600);
    _controller.reverseDuration = const Duration(milliseconds: 600);

    getOldestDate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          top: getProportionateScreenHeight(30),
          left: getProportionateScreenWidth(20),
          right: getProportionateScreenWidth(20),
        ),
        child: Column(
          children: [
            _buildTitleBar(context),
            SizedBox(height: getProportionateScreenHeight(10)),
            Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            SizedBox(height: getProportionateScreenHeight(1)),
            _buildDateBar(context),
            SizedBox(height: getProportionateScreenHeight(1)),
            Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            _buildFilter(context),
            SizedBox(height: getProportionateScreenHeight(15)),
            _buildListTask(context),
          ],
        ),
      ),
    );
  }

  _buildTitleBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => _dateController.jumpToSelection(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Jiffy(DateTime.now()).yMMMMd,
                style: Theme.of(context).textTheme.headline3!.copyWith(
                    color: Theme.of(context)
                        .textTheme
                        .headline3!
                        .color!
                        .withOpacity(0.65)),
              ),
              SizedBox(height: 5),
              Text(
                Jiffy(DateTime.now()).EEEE,
                style: Theme.of(context).textTheme.headline2!,
              ),
            ],
          ),
        ),
        SpeedDial(
          direction: SpeedDialDirection.down,
          icon: Icons.menu,
          activeIcon: Icons.close_outlined,
          backgroundColor: Colors.blue.shade800,
          foregroundColor: Colors.white,
          overlayColor:
              _curTheme == AppTheme.lightTheme ? Colors.white : Colors.grey,
          overlayOpacity: 0.9,
          spacing: 8,
          spaceBetweenChildren: 5,
          children: [
            SpeedDialChild(
              backgroundColor: Colors.blue.shade300,
              labelWidget: Text(
                "+ Add a task \t\t\t",
                style: Theme.of(context).textTheme.headline4,
              ),
              child: Icon(Icons.add, color: Colors.white),
              onTap: () => showModalBottomSheet(
                transitionAnimationController: _controller,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                context: context,
                builder: (context) => AddTaskScreen(),
              ),
            ),
            SpeedDialChild(
              backgroundColor: Colors.red.shade300,
              labelWidget: Text(
                "Recycle Bin \t\t\t",
                style: Theme.of(context).textTheme.headline4,
              ),
              child: Icon(Icons.auto_delete, color: Colors.white),
              onTap: () async {
                await Navigator.pushNamed(context, '/bin');

                if (!mounted) return;

                BlocProvider.of<TaskFilterBloc>(context).add(
                  UpdateTaskFilter(taskFilter: _taskFilter),
                );
              },
            ),
            SpeedDialChild(
                backgroundColor: Colors.grey,
                labelWidget: Text(
                  "Theme \t\t\t",
                  style: Theme.of(context).textTheme.headline4,
                ),
                child: Icon(
                  _curTheme == AppTheme.lightTheme
                      ? Icons.dark_mode_outlined
                      : Icons.light_mode_outlined,
                  color: Colors.white,
                ),
                onTap: () {
                  _curTheme = _curTheme == AppTheme.lightTheme
                      ? AppTheme.darkTheme
                      : AppTheme.lightTheme;
                  BlocProvider.of<ThemeBloc>(context).add(
                    UpdateTheme(appTheme: _curTheme),
                  );
                }),
          ],
        ),
      ],
    );
  }

  _buildDateBar(BuildContext context) {
    return DatePicker(
      _oldestDate,
      height: getProportionateScreenHeight(100),
      width: getProportionateScreenWidth(80),
      controller: _dateController,
      initialSelectedDate: DateTime.now(),
      selectionColor: Colors.blue.shade800,
      selectedTextColor: Colors.white,
      dateTextStyle: Theme.of(context).textTheme.headline3!,
      dayTextStyle: Theme.of(context).textTheme.bodyText1!,
      monthTextStyle: Theme.of(context).textTheme.bodyText1!,
      onDateChange: (date) => setState(() => _selectedDate = date),
    );
  }

  _buildListTask(BuildContext context) {
    return Expanded(
      child: BlocBuilder<TaskFilterBloc, TaskFilterState>(
        builder: (context, state) {
          if (state is TaskFilterLoading || state is TaskFilterInitial) {
            return CircleLoading();
          }

          // if (state is TaskError)
          //   return DisplayNotification(title: state.message, size: 18);

          if (state is TaskFilterLoaded) {
            if (state.filteredTasks.length == 0) {
              return DisplayNotification(
                title: "No Tasks",
                size: 32,
                initialDate: Jiffy(_selectedDate).yMd,
              );
            } else {
              List<Task> tasks = state.filteredTasks
                  .where((task) =>
                      Jiffy(task.date, 'M/d/y').format() ==
                          Jiffy(_selectedDate).format() &&
                      !task.isRemoved)
                  .toList();

              return tasks.length == 0
                  ? DisplayNotification(
                      title: "No Tasks",
                      size: 32,
                      initialDate: Jiffy(_selectedDate).yMd,
                    )
                  : ListView.separated(
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 22),
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: tasks.length,
                      itemBuilder: (context, index) => TaskCard(
                        task: tasks[index],
                      ),
                    );
            }
          } else {
            return DisplayNotification(
              title: 'Something Went Wrong. Try later',
              size: 18,
            );
          }
        },
      ),
    );
  }

  _buildFilter(BuildContext context) {
    final style = Theme.of(context)
        .textTheme
        .headline4!
        .copyWith(fontWeight: FontWeight.normal);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text('Filter By: ', style: Theme.of(context).textTheme.headline4),
        SizedBox(width: 10),
        DropdownButton<TaskFilter>(
          elevation: 1,
          alignment: AlignmentDirectional.center,
          borderRadius: BorderRadius.circular(25),
          value: _taskFilter,
          items: [
            DropdownMenuItem(
              child: Text(TaskFilter.all.name, style: style),
              value: TaskFilter.all,
            ),
            DropdownMenuItem(
              child: Text(TaskFilter.pending.name, style: style),
              value: TaskFilter.pending,
            ),
            DropdownMenuItem(
              child: Text(TaskFilter.completed.name, style: style),
              value: TaskFilter.completed,
            ),
          ],
          onChanged: ((value) => setState(() {
                _taskFilter = value!;
                BlocProvider.of<TaskFilterBloc>(context).add(
                  UpdateTaskFilter(taskFilter: _taskFilter),
                );
              })),
        ),
      ],
    );
  }
}
