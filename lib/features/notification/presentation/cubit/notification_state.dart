
import 'package:equatable/equatable.dart';

abstract class NotificationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialNotificationState extends NotificationState {}
class InitializedLocalNotificationState extends NotificationState {}
class LoadingTokenState extends NotificationState {}
class LoadedTokenState extends NotificationState {
  final String appToken ;
  LoadedTokenState({required this.appToken});
  @override
  List<Object?> get props => [appToken];
}

class SendingNotificationState extends NotificationState {}
class SentNotificationState extends NotificationState {}

class UpdatingTokenState extends NotificationState {}
class UpdatedTokenState extends NotificationState {}

class NotificationErrorState extends NotificationState {
  final String ? message ;
  NotificationErrorState({this.message});
}
