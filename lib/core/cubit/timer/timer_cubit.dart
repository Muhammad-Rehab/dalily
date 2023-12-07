

import 'dart:async';

import 'package:dalily/core/cubit/timer/timer_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimerCubit extends Cubit<TimerSate>{

  TimerCubit():super(InitialTimerState());

  Timer ? timer ;

  startPeriodicTimer({required int seconds}){
    emit(PeriodicTimerStartedState());
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if(timer.tick > seconds){
        timer.cancel();
        emit(PeriodicTimerCanceled());
      }else {
        emit(PeriodicTimerWorking());
        emit(OnPeriodicTimerState(timer: timer));
      }

    });
  }

  closeTimer(){
    emit(PeriodicTimerWorking());
    if(timer != null){
      timer!.cancel();
    }
    emit(PeriodicTimerCanceled());
  }
}