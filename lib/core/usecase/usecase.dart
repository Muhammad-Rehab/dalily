
import 'package:dalily/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

abstract class UseCase<Type,Param> {
  Future<Either<Failure,Type>> call(Param param);
}

class NoParam extends Equatable {
  @override
  List<Object?> get props => [];
}