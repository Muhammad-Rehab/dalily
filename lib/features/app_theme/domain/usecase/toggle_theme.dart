
import 'package:dalily/core/error/failure.dart';
import 'package:dalily/core/usecase/usecase.dart';
import 'package:dalily/features/app_theme/data/model/app_theme_model.dart';
import 'package:dalily/features/app_theme/domain/repositry/theme_repositry.dart';
import 'package:dartz/dartz.dart';

class ToggleThemeUseCase extends UseCase<AppThemeModel,NoParam>{
  ThemeRepository themeRepository ;
  ToggleThemeUseCase({required this.themeRepository});

  @override
  Future<Either<Failure, AppThemeModel>> call(NoParam param) => themeRepository.toggleTheme();

}