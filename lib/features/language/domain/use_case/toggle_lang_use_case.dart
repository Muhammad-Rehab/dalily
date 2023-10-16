

import 'package:dalily/core/error/failure.dart';
import 'package:dalily/core/usecase/usecase.dart';
import 'package:dalily/features/language/data/model/language_model.dart';
import 'package:dalily/features/language/domain/repository/language_repository.dart';
import 'package:dartz/dartz.dart';

class ToggleLanguageUseCase extends UseCase{
  LanguageRepository languageRepository ;
  ToggleLanguageUseCase({required this.languageRepository});

  @override
  Future<Either<Failure, LanguageModel>> call(param) => languageRepository.toggleLanguage();

}