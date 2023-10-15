import 'package:dalily/core/util/constant.dart';
import 'package:dalily/features/app_theme/data/model/app_theme_model.dart';
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
    if (sharedPreferences.getBool(AppConstant.languageKey) == null) {
      appThemeModel.themeMode = ThemeMode.light;
      await sharedPreferences.setBool(AppConstant.languageKey, false);
    } else if (sharedPreferences.getBool(AppConstant.languageKey) == true) {
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
      await sharedPreferences.setBool(AppConstant.languageKey, false);
    }else{
      appThemeModel.themeMode = ThemeMode.dark;
      await sharedPreferences.setBool(AppConstant.languageKey, true);
    }
    return appThemeModel ;
  }
}
