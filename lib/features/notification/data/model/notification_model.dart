import 'dart:convert';

import 'package:dalily/core/emum/notification_type.dart';
import 'package:dalily/core/util/app_strings.dart';
import 'package:dalily/features/notification/domain/entity/notification.dart';

class NotificationModel extends Notification {
  const NotificationModel({
    required super.type,
    super.isUserDataAccepted,
    required super.title,
    required super.content,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    NotificationType notificationType;
    switch (json['type']) {
      case AppStrings.chatNotificationType:
        notificationType = NotificationType.chat;
        break;
      case AppStrings.userDataResponseNotificationType:
        notificationType = NotificationType.userDataResponse;
        break;
      default:
        notificationType = NotificationType.general;
        break;
    }
    return NotificationModel(
        type: notificationType,
        isUserDataAccepted: jsonDecode(json['is_user_data_accepted'].toString()),
        title: json['title'],
        content: json['content']);
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'is_user_data_accepted': jsonEncode(isUserDataAccepted),
      'title': title,
      'content': content,
    };
  }
}
