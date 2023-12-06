

import 'package:dalily/core/emum/notification_type.dart';
import 'package:equatable/equatable.dart';

class Notification extends Equatable {

  final NotificationType type ;
  final bool ? isUserDataAccepted ;
  final String title ;
  final String content ;

  const Notification({required this.type,this.isUserDataAccepted,
  required this.title,required this.content,
  });

  @override
  List<Object?> get props => [title,content];

}