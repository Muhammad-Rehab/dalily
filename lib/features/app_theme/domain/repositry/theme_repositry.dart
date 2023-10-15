
import 'package:dalily/core/error/failure.dart';
import 'package:dalily/features/app_theme/data/model/app_theme_model.dart';
import 'package:dartz/dartz.dart';

abstract class ThemeRepository {

  Future<Either<Failure,AppThemeModel>> loadTheme() ;
  Future<Either<Failure,AppThemeModel>> toggleTheme() ;

}