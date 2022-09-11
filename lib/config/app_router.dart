import 'package:flutter/material.dart';
import 'package:tasks_app/models/models.dart';
import 'package:tasks_app/screens/screens.dart';
import 'package:tasks_app/widgets/widgets.dart';

class AppRouter {
  static GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();
  
  static Route onGenerateRoute(RouteSettings settings) {
    print('Current route: ${settings.name}');

    switch (settings.name) {
      case "/home":
      case HomeScreen.routeName:
        return HomeScreen.route();

      case TaskDetailsScreen.routeName:
        return TaskDetailsScreen.route(id: settings.arguments as String);

      case EditTaskScreen.routeName:
        return EditTaskScreen.route(task: settings.arguments as Task);

      case RecycleBinScreen.routeName:
        return RecycleBinScreen.route();

      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() => MaterialPageRoute(
        settings: const RouteSettings(name: "/error"),
        builder: (_) => Scaffold(
          appBar: CustomAppBar(
            title: "ERROR!",
            centerTitle: true,
          ),
          body: DisplayNotification(
            title: 'Something went wrong!',
            size: 28,
          ),
        ),
      );
}
