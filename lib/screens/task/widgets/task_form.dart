import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:tasks_app/config/app_size.dart';
import 'package:tasks_app/utils/utils.dart';

import 'input_field.dart';

String getHHss(TimeOfDay time) {
  String hour = time.hour < 10 ? "0${time.hour}" : "${time.hour}";
  String min = time.minute < 10 ? "0${time.minute}" : "${time.minute}";
  return hour + ":" + min;
}

class TaskForm extends StatefulWidget {
  TaskForm({
    Key? key,
    required this.formKey,
    required this.titleController,
    required this.notesController,
    required this.dateController,
    required this.startsController,
    required this.endsController,
    required this.alertController,
    required this.colorController,
    required this.buttonTitle,
    required this.title,
    this.onClick,
  }) : super(key: key);

  final GlobalKey<FormState> formKey;

  final TextEditingController titleController;
  final TextEditingController notesController;
  final TextEditingController dateController;
  final TextEditingController startsController;
  final TextEditingController endsController;
  final TextEditingController alertController;
  final TextEditingController colorController;

  final String buttonTitle;
  final String title;
  final Function()? onClick;

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  Map<String, String> alertMap = {
    '-1': 'None',
    '0': 'At time of task',
    '5': '5 minutes before',
    '10': '10 minutes before',
    '15': '15 minutes before',
    '30': '30 minutes before',
    '60': '60 minutes before',
  };

  final List<Color> _colorList = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.purple,
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Form(
        key: widget.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Padding(
          padding: EdgeInsets.only(
            left: getProportionateScreenWidth(20),
            right: getProportionateScreenWidth(20),
          ),
          child: Column(
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[
                        Color.fromRGBO(248, 87, 195, 1),
                        Color.fromRGBO(224, 19, 156, 1),
                      ],
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(50.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(209, 2, 99, 0.27),
                        blurRadius: 10.0,
                        spreadRadius: 5.0,
                        offset: Offset(0.0, 0.0),
                      ),
                    ],
                  ),
                  child: Image.asset('assets/fab-delete.png'),
                ),
              ),
              SizedBox(height: getProportionateScreenWidth(8)),
              Text(
                widget.title,
                style: Theme.of(context).textTheme.headline3,
              ),
              SizedBox(height: getProportionateScreenWidth(5)),
              SizedBox(
                width: widget.title != 'Add new task'
                    ? AppSize.screenWidth * 2.2 / 3
                    : AppSize.screenWidth / 3.3,
                child: Divider(thickness: 3, color: Colors.blue),
              ),
              SizedBox(height: 15),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      InputField(
                        title: 'Title',
                        hintText: 'Enter your title',
                        controller: widget.titleController,
                        validator: titleValidator,
                      ),
                      InputField(
                        title: 'Notes',
                        hintText: 'Enter your notes',
                        controller: widget.notesController,
                        validator: noteValidator,
                      ),
                      InputField(
                        title: 'Date',
                        hintText: widget.dateController.text,
                        widget: IconButton(
                          onPressed: () => _pickerDate(),
                          icon: Icon(
                            Icons.calendar_today_rounded,
                            color: Theme.of(context).hintColor,
                            size: getProportionateScreenWidth(25),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: InputField(
                              title: 'Starts',
                              hintText: widget.startsController.text,
                              widget: IconButton(
                                onPressed: () => _pickerTime(isStartTime: true),
                                icon: Icon(
                                  Icons.access_time_rounded,
                                  color: Theme.of(context).hintColor,
                                  size: getProportionateScreenWidth(25),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: getProportionateScreenWidth(15)),
                          Expanded(
                            child: InputField(
                              title: 'Ends',
                              hintText: widget.endsController.text,
                              widget: IconButton(
                                onPressed: () =>
                                    _pickerTime(isStartTime: false),
                                icon: Icon(
                                  Icons.access_time_rounded,
                                  color: Theme.of(context).hintColor,
                                  size: getProportionateScreenWidth(25),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      InputField(
                        title: "Alert",
                        hintText: alertMap[widget.alertController.text] ?? "==",
                        widget: DropdownButton(
                          icon: Icon(
                            Icons.keyboard_arrow_down_outlined,
                            color: Colors.grey,
                            size: getProportionateScreenWidth(30),
                          ),
                          iconSize: getProportionateScreenWidth(20),
                          items: alertMap.keys
                              .map<DropdownMenuItem<String>>(
                                (e) => DropdownMenuItem<String>(
                                  value: e.toString(),
                                  child:
                                      Text(alertMap[e.toString()].toString()),
                                ),
                              )
                              .toList(),
                          onChanged: (value) => setState(() {
                            widget.alertController.text = value.toString();
                          }),
                        ),
                      ),
                      SizedBox(height: getProportionateScreenHeight(5)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildListColor(),
                          FloatingActionButton.extended(
                            onPressed: widget.onClick,
                            label: Text(
                              widget.buttonTitle,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(color: Colors.white),
                            ),
                            backgroundColor:
                                HexColor(widget.colorController.text),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  getProportionateScreenWidth(15)),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: getProportionateScreenHeight(15)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column _buildListColor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          " Color",
          style: Theme.of(context).textTheme.headline4,
        ),
        SizedBox(height: getProportionateScreenHeight(10)),
        Wrap(
          spacing: 7,
          children: List.generate(
            _colorList.length,
            (index) => GestureDetector(
              onTap: () => setState(() {
                widget.colorController.text =
                    _colorList[index].value.toRadixString(16);
              }),
              child: CircleAvatar(
                radius: getProportionateScreenWidth(12),
                backgroundColor: _colorList[index],
                child: widget.colorController.text ==
                        _colorList[index].value.toRadixString(16)
                    ? Icon(
                        Icons.done,
                        color: Colors.white,
                        size: getProportionateScreenWidth(20),
                      )
                    : null,
              ),
            ),
          ),
        )
      ],
    );
  }

  _pickerDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        widget.dateController.text = Jiffy(pickedDate).yMd;
      });
    }
  }

  _pickerTime({required bool isStartTime}) async {
    var pickedTime = await showTimePicker(
        context: context,
        initialEntryMode: TimePickerEntryMode.input,
        initialTime: TimeOfDay.now(),
        builder: (context, childWidget) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              // Using 24-Hour format
              alwaysUse24HourFormat: true,
            ),
            // If you want 12-Hour format, just change alwaysUse24HourFormat to false or remove all the builder arguments
            child: childWidget!,
          );
        });

    if (pickedTime != null) {
      setState(() {
        if (isStartTime) {
          widget.startsController.text = getHHss(pickedTime);
        } else {
          widget.endsController.text = getHHss(pickedTime);
        }
      });
    }
  }
}
