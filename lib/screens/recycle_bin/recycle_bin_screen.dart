import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:tasks_app/blocs/blocs.dart';
import 'package:tasks_app/widgets/widgets.dart';

import 'body.dart';

class RecycleBinScreen extends StatelessWidget {
  const RecycleBinScreen({Key? key}) : super(key: key);

  static const String routeName = "/bin";
  static Route route() => MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => RecycleBinScreen(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Recycle Bin"),
      body: SafeArea(
        child: Body(),
      ),
      floatingActionButton: SpeedDial(
        direction: SpeedDialDirection.up,
        icon: Icons.menu,
        activeIcon: Icons.close_outlined,
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        overlayColor: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.grey,
        overlayOpacity: 0.5,
        spacing: 8,
        spaceBetweenChildren: 5,
        children: [
          SpeedDialChild(
            backgroundColor: Colors.green.shade300,
            labelWidget: Text(
              "Restore all removed tasks \t\t\t",
              style: Theme.of(context).textTheme.headline4,
            ),
            child: Icon(Icons.restore_from_trash_outlined, color: Colors.white),
            onTap: () => BlocProvider.of<TaskBloc>(context)
                .add(restoreAllTasksInTrash()),
          ),
          SpeedDialChild(
            backgroundColor: Colors.red.shade300,
            labelWidget: Text(
              "Clean all removed tasks \t\t\t",
              style: Theme.of(context).textTheme.headline4,
            ),
            child: Icon(Icons.clear_all_outlined, color: Colors.white),
            onTap: () =>
                BlocProvider.of<TaskBloc>(context).add(deleteAllTasksInTrash()),
          ),
        ],
      ),
    );
  }
}
