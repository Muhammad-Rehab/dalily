import 'dart:ui';

import 'package:dalily/core/util/app_strings.dart';
import 'package:dalily/features/language/data/model/language_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LanguageLocalDataResource {
  Future<LanguageModel> loadLanguage();

  Future<LanguageModel> toggleLanguage();
}

class LanguageLocalDataResourceImp extends LanguageLocalDataResource {
  LanguageModel languageModel;

  final SharedPreferences sharedPreferences;

  LanguageLocalDataResourceImp({required this.languageModel, required this.sharedPreferences});

  @override
  Future<LanguageModel> loadLanguage() async {
    if (sharedPreferences.getBool(AppStrings.languageKey) == null) {
      languageModel.locale = PlatformDispatcher.instance.locale;
      await sharedPreferences.setBool(AppStrings.languageKey,
          (languageModel.locale.countryCode == AppStrings.arabicLanguageCode) ? true : false);
    } else if (sharedPreferences.getBool(AppStrings.languageKey) == true) {
      languageModel.locale = const Locale(AppStrings.arabicLanguageCode);
    } else {
      languageModel.locale = const Locale(AppStrings.englishLanguageCode);
    }
    return languageModel;
  }

  @override
  Future<LanguageModel> toggleLanguage() async {
    if(languageModel.locale.languageCode == AppStrings.arabicLanguageCode){
      languageModel.locale = const Locale(AppStrings.englishLanguageCode);
      await sharedPreferences.setBool(AppStrings.languageKey, false);
    }else{
      languageModel.locale = const Locale(AppStrings.arabicLanguageCode);
      await sharedPreferences.setBool(AppStrings.languageKey, true);
    }
    return languageModel ;
  }
}
