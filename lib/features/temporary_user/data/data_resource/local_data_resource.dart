

import 'package:dalily/core/util/app_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class TempUserLocalResource {
  String? getTempUserId();
  Future<void> addTempUserId(String id);
}

class TempUserLocalResourceImp extends TempUserLocalResource {
  final SharedPreferences sharedPreferences ;

  TempUserLocalResourceImp({required this.sharedPreferences});

  @override
  Future<void> addTempUserId(String id) async {
    await sharedPreferences.setString(AppStrings.tempUserSharedKey, id);
  }

  @override
  String ? getTempUserId(){
    String ? hold =  sharedPreferences.getString(AppStrings.tempUserSharedKey);
    return hold ;
  }

}