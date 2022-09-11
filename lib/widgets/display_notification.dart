import 'package:flutter/material.dart';
import 'package:tasks_app/screens/screens.dart';

class DisplayNotification extends StatelessWidget {
  const DisplayNotification({
    Key? key,
    required this.title,
    required this.size,
    this.initialDate,
  }) : super(key: key);

  final String title;
  final double size;
  final String? initialDate;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            visible: title == "No Tasks",
            child: InkWell(
              onTap: () => showModalBottomSheet(
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                context: context,
                builder: (context) => AddTaskScreen(initialDate: initialDate),
              ),
              child: Stack(
                children: [
                  Image.asset(
                    "assets/list_task.png",
                    width: size * 4,
                    height: size * 5,
                  ),
                  Positioned(
                    bottom: 5,
                    right: 0,
                    child: Icon(
                      Icons.add,
                      size: size * 1.5,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: size,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
