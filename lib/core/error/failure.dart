
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable{
  String ? message ;
  Failure({this.message});

  @override
  List<Object?> get props => [message];
}

class CashFailure extends Failure {
  CashFailure({super.message});
}

class ServerFailure extends Failure {
  ServerFailure({super.message});
}
