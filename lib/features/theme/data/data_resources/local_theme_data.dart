import 'package:dalily/core/util/app_strings.dart';
import 'package:dalily/features/theme/data/model/app_theme_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalThemeData{
  Future<AppThemeModel> loadLocalTheme();
  Future<AppThemeModel> toggleTheme();
}

class LocalThemeDataImp extends LocalThemeData{
  AppThemeModel appThemeModel;

  SharedPreferences sharedPreferences;

  LocalThemeDataImp({required this.sharedPreferences,required this.appThemeModel});

  @override
  Future<AppThemeModel> loadLocalTheme() async {
    if (sharedPreferences.getBool(AppStrings.themeKey) == null) {
      appThemeModel.themeMode = ThemeMode.light;
      await sharedPreferences.setBool(AppStrings.themeKey, false);
    } else if (sharedPreferences.getBool(AppStrings.themeKey) == true) {
      appThemeModel.themeMode = ThemeMode.dark;
    } else {
      appThemeModel.themeMode =  ThemeMode.light;
    }
    return appThemeModel;
  }

  @override
  Future<AppThemeModel> toggleTheme() async {
    if(appThemeModel.themeMode == ThemeMode.dark){
      appThemeModel.themeMode = ThemeMode.light;
      await sharedPreferences.setBool(AppStrings.themeKey, false);
    }else{
      appThemeModel.themeMode = ThemeMode.dark;
      await sharedPreferences.setBool(AppStrings.themeKey, true);
    }
    return appThemeModel ;
  }
}
