
import 'package:equatable/equatable.dart';

class RateState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RateInitialState extends RateState {}

class AddingRateState extends RateState {}

class AddedRateState extends RateState {}

class ErrorRateState extends RateState {}
