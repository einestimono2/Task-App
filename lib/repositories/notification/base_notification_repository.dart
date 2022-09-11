import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tasks_app/models/models.dart';

abstract class BaseNotificationRepository {
  Future<void> addNotification({
    required int id,
    required String title,
    required String body,
  });

  Future<List<PendingNotificationRequest>> getAllPendingNotifications();

  Future<void> addScheduledNotification({
    required Task task,
  });

  Future<void> deleteScheduledNotification({
    required Task task,
  });

  Future<void> addNotificationWithPayload({
    required int id,
    required String title,
    required String body,
    required String payload,
  });
}
