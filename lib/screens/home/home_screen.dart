import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks_app/config/app_size.dart';
import 'package:tasks_app/repositories/notification/notification_repository.dart';
import 'package:tasks_app/screens/home/body.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const String routeName = "/";
  static Route route() => MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => HomeScreen(),
      );

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    checkNotifications();
  }

  //Click on the notification to see the task details
  checkNotifications() async {
    await RepositoryProvider.of<NotificationRepository>(context, listen: false)
        .checkForNotifications();
  }

  @override
  Widget build(BuildContext context) {
    AppSize().init(context);

    return Scaffold(
      body: Body(),
    );
  }
}
