import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:tasks_app/config/app_router.dart';
import 'package:tasks_app/models/models.dart';
import 'package:tasks_app/repositories/repositories.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationRepository extends BaseNotificationRepository {
  late FlutterLocalNotificationsPlugin _localNotificationsPlugin;
  late NotificationDetails _notificationDetails;

  NotificationRepository() {
    // NotificationsPlugin
    _localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _initNotificationsPlugin();
    // NotificationDetails
    _initNotificationDetails();
    // Timezone
    _initTimeZones();

    _showAll();
  }

  _showAll() async {
    final List<PendingNotificationRequest> pendingNotificationRequests =
        await _localNotificationsPlugin.pendingNotificationRequests();

    print(pendingNotificationRequests.length);
    pendingNotificationRequests.forEach(
      (e) => print(
        'ID: ${e.id}, Title: ${e.title}, Body: ${e.body}, Payload: ${e.payload}',
      ),
    );
  }

  _initNotificationsPlugin() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    IOSInitializationSettings iosInitializationSettings =
        IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
    );

    final InitializationSettings settings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _localNotificationsPlugin.initialize(
      settings,
      onSelectNotification: _onSelectNotification,
    );
  }

  _initNotificationDetails() {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'description',
      importance: Importance.max,
      priority: Priority.max,
      enableVibration: true,
    );

    const IOSNotificationDetails iosNotificationDetails =
        IOSNotificationDetails();

    _notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );
  }

  _initTimeZones() async {
    tz.initializeTimeZones();
    final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName!));
  }

  _onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) {
    print('ID: ${id}');
  }

  _onSelectNotification(String? payload) async {
    print('Payload: $payload');
    if (payload != null && payload.isNotEmpty) {
      await Navigator.of(AppRouter.navigatorKey!.currentContext!).pushNamed(
        '/task-details',
        arguments: payload,
      );
    }
  }

  @override
  Future<void> addNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    await _localNotificationsPlugin.show(id, title, body, _notificationDetails);
  }

  @override
  Future<void> addNotificationWithPayload({
    required int id,
    required String title,
    required String body,
    required String payload,
  }) async {
    await _localNotificationsPlugin.show(
      id,
      title,
      body,
      _notificationDetails,
      payload: payload,
    );
  }

  @override
  Future<List<PendingNotificationRequest>> getAllPendingNotifications() async {
    final List<PendingNotificationRequest> pendingNotificationRequests =
        await _localNotificationsPlugin.pendingNotificationRequests();

    return pendingNotificationRequests;
  }

  @override
  Future<void> addScheduledNotification({
    required Task task,
  }) async {
    if (task.alert == -1) return;

    final int hour = int.parse(task.starts.split(':')[0]);
    final int minutes = int.parse(task.starts.split(':')[1]);

    DateTime scheduleDate = DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, hour, minutes)
        .subtract(Duration(minutes: task.alert));

    if (scheduleDate.isBefore(DateTime.now())) {
      print('Start time of task < now!');
      await deleteScheduledNotification(task: task);
      return;
    }

    print('Task #${task.id}: ${scheduleDate}');

    await _localNotificationsPlugin.zonedSchedule(
      task.id.hashCode,
      task.title,
      task.notes,
      tz.TZDateTime.from(scheduleDate, tz.local),
      _notificationDetails,
      payload: task.id,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  @override
  Future<void> deleteScheduledNotification({required Task task}) async {
    List<PendingNotificationRequest> pendingNotificationRequests =
        await getAllPendingNotifications();

    int index = pendingNotificationRequests.indexWhere((element) =>
        element.id == task.id.hashCode && element.payload == task.id);

    if (index != -1) await _localNotificationsPlugin.cancel(task.id.hashCode);
  }

  checkForNotifications() async {
    final details =
        await _localNotificationsPlugin.getNotificationAppLaunchDetails();

    if (details != null && details.didNotificationLaunchApp) {
      // _onSelectNotification(details.payload);
      print(details.payload);
    }
  }
}
