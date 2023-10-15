import 'package:dalily/config/super_injection_container.dart';
import 'package:dalily/features/app_theme/data/data_resources/local_theme_data.dart';
import 'package:dalily/features/app_theme/data/model/app_theme_model.dart';
import 'package:dalily/features/app_theme/data/repository/theme_repository_imp.dart';
import 'package:dalily/features/app_theme/domain/repositry/theme_repositry.dart';
import 'package:dalily/features/app_theme/domain/usecase/load_Theme.dart';
import 'package:dalily/features/app_theme/domain/usecase/toggle_theme.dart';
import 'package:dalily/features/app_theme/presentation/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';

themeInjectionContainer() {
  serverLocator.registerFactory(() => ThemeCubit(
      sharedPreferences: serverLocator(),
      loadThemeUseCase: serverLocator(),
      toggleThemeUseCase: serverLocator()),
  );
  serverLocator.registerLazySingleton(() => LoadThemeUseCase(themeRepository: serverLocator()));
  serverLocator.registerLazySingleton(() => ToggleThemeUseCase(themeRepository: serverLocator()));

  serverLocator.registerLazySingleton<ThemeRepository>(() => ThemeRepositoryImp(localThemeData: serverLocator()));
  serverLocator.registerLazySingleton<LocalThemeData>(() =>
      LocalThemeDataImp(sharedPreferences: serverLocator(),appThemeModel: serverLocator()));

  serverLocator.registerLazySingleton(() => AppThemeModel(themeMode: ThemeMode.light));
}
