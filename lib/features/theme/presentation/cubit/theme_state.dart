import 'package:equatable/equatable.dart';

abstract class ThemeState extends Equatable {

  @override
  List<Object?> get props => [];
}

class InitialThemeState extends ThemeState {}

class IsLoadingThemeState extends ThemeState {}

class LoadedThemeState extends ThemeState {
  bool isDark ;
  LoadedThemeState({required this.isDark});

  @override
  List<Object?> get props => [isDark];
}
class FailedThemeState extends ThemeState {}


