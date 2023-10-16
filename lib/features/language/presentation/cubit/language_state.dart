
import 'package:equatable/equatable.dart';

abstract class LanguageState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitializeLanguageState extends LanguageState {}

class LanguageLoadedState extends LanguageState {}

class LanguageIsLoadingState extends LanguageState {}

class LanguageFailedState extends LanguageState {}