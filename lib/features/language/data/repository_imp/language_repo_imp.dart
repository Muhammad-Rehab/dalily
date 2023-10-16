
import 'package:dalily/core/error/failure.dart';
import 'package:dalily/features/language/data/data_resource/local_data_resource.dart';
import 'package:dalily/features/language/data/model/language_model.dart';
import 'package:dalily/features/language/domain/repository/language_repository.dart';
import 'package:dartz/dartz.dart';

class LanguageRepoImp extends LanguageRepository {

  LanguageLocalDataResource languageLocalDataResource ;
  LanguageRepoImp({required this.languageLocalDataResource});

  @override
  Future<Either<Failure, LanguageModel>> loadLanguage() async{
    try{
      return Right(await languageLocalDataResource.loadLanguage());
    }catch (e) {
      return Left(CashFailure());
    }
  }

  @override
  Future<Either<Failure, LanguageModel>> toggleLanguage() async {
    try {
      return Right( await languageLocalDataResource.toggleLanguage());
    }catch(e){
      return Left(CashFailure());
    }
  }

}