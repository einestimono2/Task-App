import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks_app/blocs/blocs.dart';
import 'package:tasks_app/repositories/repositories.dart';
import 'package:tasks_app/screens/screens.dart';
import 'package:tasks_app/simple_bloc_observer.dart';

import 'config/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = SimpleBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => TaskRepository()),
        RepositoryProvider(create: (context) => NotificationRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ThemeBloc(),
          ),
          BlocProvider(
            create: (context) => TaskBloc(
              taskRepository: context.read<TaskRepository>(),
              notificationRepository: context.read<NotificationRepository>(),
            )..add(LoadTasks()),
          ),
          BlocProvider(
            create: (context) => TaskDetailsBloc(
              taskRepository: context.read<TaskRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) =>
                TaskFilterBloc(taskBloc: BlocProvider.of<TaskBloc>(context)),
          ),
        ],
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Tasks App',
              theme: state.themeData,
              onGenerateRoute: AppRouter.onGenerateRoute,
              initialRoute: HomeScreen.routeName,
              navigatorKey: AppRouter.navigatorKey,
            );
          },
        ),
      ),
    );
  }
}
