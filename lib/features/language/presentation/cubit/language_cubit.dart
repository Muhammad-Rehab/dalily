
import 'package:dalily/config/theme.dart';
import 'package:dalily/core/error/failure.dart';
import 'package:dalily/core/usecase/usecase.dart';
import 'package:dalily/core/util/app_strings.dart';
import 'package:dalily/features/language/data/model/language_model.dart';
import 'package:dalily/features/language/domain/use_case/load_language_use_case.dart';
import 'package:dalily/features/language/domain/use_case/toggle_lang_use_case.dart';
import 'package:dalily/features/language/presentation/cubit/language_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguageCubit extends Cubit<LanguageState> {

  bool isArabic = true ;
  LoadLanguageUseCase loadLanguageUseCase ;
  ToggleLanguageUseCase toggleLanguageUseCase ;

  LanguageCubit({required this.toggleLanguageUseCase,required this.loadLanguageUseCase}):super(InitializeLanguageState());

  Future<void> loadLanguage ()async{
    emit(LanguageIsLoadingState());
    final Either<Failure,LanguageModel> response = await loadLanguageUseCase.call(NoParam());
    emit(response.fold((failure) {
      isArabic = true ;
      return LanguageFailedState();
    }, (languageModel) {
      isArabic = languageModel.locale.languageCode == AppStrings.arabicLanguageCode ;
      return LanguageLoadedState();
    }));
  }

  Future<void> toggleLanguage ()async{
    emit(LanguageIsLoadingState());
    final response = await toggleLanguageUseCase.call(NoParam());
    emit(response.fold((failure) => LanguageFailedState(), (languageModel){
      isArabic = languageModel.locale.languageCode == AppStrings.arabicLanguageCode ;
      return LanguageLoadedState();
    }));
  }

}