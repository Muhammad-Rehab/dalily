
import 'package:dalily/features/language/presentation/cubit/language_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class FontHelper {

  static TextStyle getDefaultTextFamily(BuildContext context){
      if(context.watch<LanguageCubit>().isArabic){
        return GoogleFonts.cairo();
      }else{
        return GoogleFonts.lato();
    }
  }
}