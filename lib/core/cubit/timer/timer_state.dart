


import 'dart:async';

import 'package:equatable/equatable.dart';

abstract class TimerSate extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialTimerState extends TimerSate{}

class PeriodicTimerStartedState extends TimerSate {}
class OnPeriodicTimerState extends TimerSate {
  final Timer timer ;
  OnPeriodicTimerState({required this.timer});
  @override
  List<Object?> get props => [timer];
}

class PeriodicTimerCanceled extends TimerSate {}
class PeriodicTimerWorking extends TimerSate {}