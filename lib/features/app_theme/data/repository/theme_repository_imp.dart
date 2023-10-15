
import 'package:dalily/core/error/failure.dart';
import 'package:dalily/features/app_theme/data/data_resources/local_theme_data.dart';
import 'package:dalily/features/app_theme/data/model/app_theme_model.dart';
import 'package:dalily/features/app_theme/domain/repositry/theme_repositry.dart';
import 'package:dartz/dartz.dart';

class ThemeRepositoryImp extends ThemeRepository {

  LocalThemeData localThemeData ;
  ThemeRepositoryImp({required this.localThemeData});

  @override
  Future<Either<Failure, AppThemeModel>> loadTheme() async {
    try{
      return Right(await localThemeData.loadLocalTheme());
    }catch (e){
     return Left(CashFailure());
    }
  }

  @override
  Future<Either<Failure, AppThemeModel>> toggleTheme() async{
    try{
      return Right(await localThemeData.toggleTheme());
    }catch(e){
      return Left(CashFailure());
    }
  }

}