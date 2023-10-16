


import 'package:dalily/config/super_injection_container.dart';
import 'package:dalily/features/language/data/data_resource/local_data_resource.dart';
import 'package:dalily/features/language/data/model/language_model.dart';
import 'package:dalily/features/language/data/repository_imp/language_repo_imp.dart';
import 'package:dalily/features/language/domain/repository/language_repository.dart';
import 'package:dalily/features/language/domain/use_case/load_language_use_case.dart';
import 'package:dalily/features/language/domain/use_case/toggle_lang_use_case.dart';
import 'package:dalily/features/language/presentation/cubit/language_cubit.dart';
import 'package:flutter/foundation.dart';

languageInjectionContainer  (){

  serverLocator.registerFactory(() => LanguageCubit(toggleLanguageUseCase: serverLocator(),
      loadLanguageUseCase: serverLocator()));

  serverLocator.registerLazySingleton(() => ToggleLanguageUseCase(languageRepository: serverLocator()));
  serverLocator.registerLazySingleton(() => LoadLanguageUseCase(languageRepository: serverLocator()));

  serverLocator.registerLazySingleton<LanguageRepository>(() => LanguageRepoImp(languageLocalDataResource: serverLocator()));

  serverLocator.registerLazySingleton<LanguageLocalDataResource>(() => LanguageLocalDataResourceImp(languageModel: serverLocator(),
      sharedPreferences: serverLocator()) );

  serverLocator.registerLazySingleton(() => LanguageModel(locale:PlatformDispatcher.instance.locale ));

}