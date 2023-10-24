
import 'package:dalily/features/authentication/data/model/service_owner_model.dart';
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

  CodeIsSendState({this.serviceOwnerModel,required this.phoneNumber,this.fromRegister = false});
}

class AuthExceptionState extends AuthenticationState {
  String message;
  AuthExceptionState({required this.message});

  @override
  List<Object?> get props => [message];
}

class AuthLoggedInState extends AuthenticationState {
  String id ;
  AuthLoggedInState({required this.id});

  @override
  List<Object?> get props => [id];
}

class AuthRegisteredState extends AuthenticationState {}

class Timing extends AuthenticationState {
  int seconds ;
  Timing({required this.seconds});
}
class SecondPassed extends AuthenticationState {}

