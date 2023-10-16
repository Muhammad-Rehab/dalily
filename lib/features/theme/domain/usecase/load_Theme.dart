import 'package:dalily/core/error/failure.dart';
import 'package:dalily/core/usecase/usecase.dart';
import 'package:dalily/features/theme/data/model/app_theme_model.dart';
import 'package:dalily/features/theme/domain/repositry/theme_repositry.dart';
import 'package:dartz/dartz.dart';

class LoadThemeUseCase extends UseCase<AppThemeModel,NoParam>{
  ThemeRepository themeRepository ;

  LoadThemeUseCase({required this.themeRepository});

  @override
  Future<Either<Failure, AppThemeModel>> call(param) =>  themeRepository.loadTheme() ;


}