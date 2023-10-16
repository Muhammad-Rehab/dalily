

import 'package:dalily/core/error/failure.dart';
import 'package:dalily/core/usecase/usecase.dart';
import 'package:dalily/features/theme/data/model/app_theme_model.dart';
import 'package:dalily/features/theme/domain/usecase/load_Theme.dart';
import 'package:dalily/features/theme/domain/usecase/toggle_theme.dart';
import 'package:dalily/features/theme/presentation/cubit/theme_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeState> {

  SharedPreferences sharedPreferences ;
  LoadThemeUseCase loadThemeUseCase ;
  ToggleThemeUseCase toggleThemeUseCase ;
  bool isDark = false ;

  ThemeCubit({required this.sharedPreferences,required this.loadThemeUseCase,required this.toggleThemeUseCase}):super(InitialThemeState());

  Future<void> loadTheme() async {
    emit(IsLoadingThemeState());
    Either<Failure,AppThemeModel> response = await loadThemeUseCase.call(NoParam());

   emit( response.fold((failure) {
     isDark = false ;
     return FailedThemeState();
   }, (appThemeModel) {
     isDark = appThemeModel.themeMode == ThemeMode.dark;
     return LoadedThemeState(isDark: isDark);
   }));
  }

  Future<void> toggleTheme() async {
    emit(IsLoadingThemeState());
    Either<Failure,AppThemeModel> response = await  toggleThemeUseCase.call(NoParam());
    emit(response.fold((failure) => FailedThemeState(), (appThemeModel) {
      isDark = appThemeModel.themeMode == ThemeMode.dark ;
      return LoadedThemeState(isDark: isDark);
    }));
  }


}