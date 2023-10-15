

import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt serverLocator = GetIt.instance;

superInjectionContainer()async{
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  serverLocator.registerLazySingleton(() => sharedPreferences);
}
