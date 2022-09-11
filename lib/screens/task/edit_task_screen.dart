import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:tasks_app/blocs/blocs.dart';
import 'package:tasks_app/config/app_size.dart';
import 'package:tasks_app/models/models.dart';
import 'package:tasks_app/screens/task/widgets/task_form.dart';
import 'package:tasks_app/utils/utils.dart';
import 'package:tasks_app/widgets/widgets.dart';

class EditTaskScreen extends StatefulWidget {
  static const String routeName = "/edit";
  static Route route({required Task task}) => MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => EditTaskScreen(task: task),
      );

  const EditTaskScreen({Key? key, required this.task}) : super(key: key);

  final Task task;

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  bool loading = false;
  final now = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController,
      _notesController,
      _dateController,
      _startsController,
      _endsController,
      _alertController,
      _colorController;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.task.title);
    _notesController = TextEditingController(text: widget.task.notes);
    _dateController = TextEditingController(text: widget.task.date);
    _startsController = TextEditingController(text: widget.task.starts);
    _endsController = TextEditingController(text: widget.task.ends);
    _alertController =
        TextEditingController(text: widget.task.alert.toString());
    _colorController = TextEditingController(text: widget.task.color);
  }

  _editTask() async {
    if (_startsController.text.compareTo(_endsController.text) > 0) {
      showSnackBar(context, "Invalid time!");
      return;
    } else if (Jiffy(_dateController.text, 'M/d/y').dateTime.compareTo(now) <
        0) {
      showSnackBar(context, "Invalid date (< now)!");
      return;
    }

    if (_formKey.currentState!.validate()) {
      BlocProvider.of<TaskBloc>(context).add(
        UpdateTask(
          task: widget.task.copyWith(
            title: _titleController.text,
            notes: _notesController.text,
            date: _dateController.text,
            starts: _startsController.text,
            ends: _endsController.text,
            color: _colorController.text,
            alert: int.parse(_alertController.text),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TaskBloc, TaskState>(
      listener: (context, state) {
        if (state is TaskLoading) {
          setState(() {
            loading = true;
          });
        }

        if (state is TaskLoaded) {
          setState(() {
            loading = false;
          });

          showSnackBar(context, "Updated the task!");
          Navigator.pushReplacementNamed(context, '/home');
        }

        if (state is TaskError) {
          setState(() {
            loading = false;
          });

          showSnackBar(context, state.message);
        }
      },
      child: Container(
        height: AppSize.screenHeight * 0.90,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: Container(
            height: AppSize.screenHeight * 0.90,
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Positioned(
                  top: AppSize.screenHeight / 30,
                  left: 0,
                  child: Container(
                    height: AppSize.screenHeight,
                    width: AppSize.screenWidth,
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Theme.of(context).backgroundColor
                          : Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.elliptical(175, 50),
                      ),
                    ),
                  ),
                ),
                TaskForm(
                  title: 'Task #${widget.task.id}',
                  formKey: _formKey,
                  titleController: _titleController,
                  notesController: _notesController,
                  dateController: _dateController,
                  startsController: _startsController,
                  endsController: _endsController,
                  alertController: _alertController,
                  colorController: _colorController,
                  buttonTitle: '~ UPDATE TASK',
                  onClick: _editTask,
                ),
                loading ? CircleLoading() : SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
