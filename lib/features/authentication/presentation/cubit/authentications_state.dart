
import 'package:dalily/features/authentication/data/model/service_owner_model.dart';
import 'package:dalily/features/items/data/model/ItemModel.dart';
import 'package:equatable/equatable.dart';

class AuthenticationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialAuthenticationState extends AuthenticationState {}

class IsLoggingInState extends AuthenticationState {}
class IsSigningUpState extends AuthenticationState {}
class IsSendingOtpState extends AuthenticationState {}
class RegisterScreenState extends AuthenticationState {}
class LogInScreenState extends AuthenticationState {}


class CodeIsSendState extends AuthenticationState {
  String phoneNumber ;
  bool fromRegister ;
  ServiceOwnerModel ? serviceOwnerModel ;
  ItemModel ? itemModel ;

  CodeIsSendState({this.serviceOwnerModel,required this.phoneNumber,this.fromRegister = false,this.itemModel});
}

class AuthExceptionState extends AuthenticationState {
  final String message;
  AuthExceptionState({required this.message});

  @override
  List<Object?> get props => [message];
}

class AuthLoggedInState extends AuthenticationState {
  final String id ;
  AuthLoggedInState({required this.id});

  @override
  List<Object?> get props => [id];
}

class AuthRegisteredState extends AuthenticationState {}

class Timing extends AuthenticationState {
  final int seconds ;
  Timing({required this.seconds});
}
class SecondPassed extends AuthenticationState {}

class LoggingOutState extends AuthenticationState {}
class UserLoggedOutState extends AuthenticationState {}


