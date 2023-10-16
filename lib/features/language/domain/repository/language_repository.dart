
import 'package:dalily/core/error/failure.dart';
import 'package:dalily/features/language/data/model/language_model.dart';
import 'package:dartz/dartz.dart';

abstract class LanguageRepository {

  Future<Either<Failure,LanguageModel>> loadLanguage();
  Future<Either<Failure,LanguageModel>> toggleLanguage();
}