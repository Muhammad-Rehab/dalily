
import 'package:dalily/features/language/presentation/cubit/language_cubit.dart';
import 'package:dalily/features/theme/presentation/cubit/theme_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';


TextStyle displayLarge(BuildContext context) {
  if (BlocProvider.of<LanguageCubit>(context).isArabic) {
    return GoogleFonts.tajawal().copyWith(
      fontSize: 30 ,
      fontWeight: FontWeight.bold,
        color: context.read<ThemeCubit>().isDark
            ? const Color.fromRGBO(216, 233, 168, 1)
            : const Color.fromRGBO(25, 26, 25, 1),
    );
  } else {
    return GoogleFonts.lato().copyWith(
      fontSize: 30 ,
      fontWeight: FontWeight.bold,
      color: context.read<ThemeCubit>().isDark
          ? const Color.fromRGBO(216, 233, 168, 1)
          : const Color.fromRGBO(25, 26, 25, 1),
    );
  }
}

TextStyle displayMedium(BuildContext context) {
  if (BlocProvider.of<LanguageCubit>(context).isArabic) {
    return GoogleFonts.tajawal().copyWith(
      fontSize: 28 ,
      fontWeight: FontWeight.bold,
        color: context.read<ThemeCubit>().isDark
            ? const Color.fromRGBO(216, 233, 168, 1)
            : const Color.fromRGBO(25, 26, 25, 1),
    );
  } else {
    return GoogleFonts.lato().copyWith(
      fontSize: 28 ,
      fontWeight: FontWeight.bold,
      color: context.read<ThemeCubit>().isDark
          ? const Color.fromRGBO(216, 233, 168, 1)
          : const Color.fromRGBO(25, 26, 25, 1),
    );
  }
}

TextStyle displaySmall(BuildContext context) {
  if (BlocProvider.of<LanguageCubit>(context).isArabic) {
    return GoogleFonts.tajawal().copyWith(
      fontSize: 26 ,
      fontWeight: FontWeight.bold,
        color: context.read<ThemeCubit>().isDark
            ? const Color.fromRGBO(216, 233, 168, 1)
            : const Color.fromRGBO(25, 26, 25, 1),
    );
  } else {
    return GoogleFonts.lato().copyWith(
      fontSize: 26 ,
      fontWeight: FontWeight.bold,
      color: context.read<ThemeCubit>().isDark
          ? const Color.fromRGBO(216, 233, 168, 1)
          : const Color.fromRGBO(25, 26, 25, 1),
    );
  }
}

TextStyle titleLarge(BuildContext context) {
  if (BlocProvider.of<LanguageCubit>(context).isArabic) {
    return GoogleFonts.tajawal().copyWith(
      fontSize: 24 ,
      fontWeight: FontWeight.bold,
        color: context.read<ThemeCubit>().isDark
            ? const Color.fromRGBO(216, 233, 168, 1)
            : const Color.fromRGBO(25, 26, 25, 1),
    );
  } else {
    return GoogleFonts.lato().copyWith(
      fontSize: 24 ,
      fontWeight: FontWeight.bold,
      color: context.read<ThemeCubit>().isDark
          ? const Color.fromRGBO(216, 233, 168, 1)
          : const Color.fromRGBO(25, 26, 25, 1),
    );
  }
}

TextStyle titleMedium(BuildContext context) {
  if (BlocProvider.of<LanguageCubit>(context).isArabic) {
    return GoogleFonts.tajawal().copyWith(
      fontSize: 22 ,
      fontWeight: FontWeight.bold,
      color: context.read<ThemeCubit>().isDark
          ? const Color.fromRGBO(216, 233, 168, 1)
          : const Color.fromRGBO(25, 26, 25, 1),
    );
  } else {
    return GoogleFonts.lato().copyWith(
      fontSize: 22 ,
      fontWeight: FontWeight.bold,
      color: context.read<ThemeCubit>().isDark
          ? const Color.fromRGBO(216, 233, 168, 1)
          : const Color.fromRGBO(25, 26, 25, 1),
    );
  }
}

TextStyle titleSmall(BuildContext context) {
  if (BlocProvider.of<LanguageCubit>(context).isArabic) {
    return GoogleFonts.tajawal().copyWith(
      fontSize: 20 ,
      fontWeight: FontWeight.bold,
      color: context.read<ThemeCubit>().isDark
          ? const Color.fromRGBO(216, 233, 168, 1)
          : const Color.fromRGBO(25, 26, 25, 1),
    );
  } else {
    return GoogleFonts.lato().copyWith(
      fontSize: 20 ,
      fontWeight: FontWeight.bold,
      color: context.read<ThemeCubit>().isDark
          ? const Color.fromRGBO(216, 233, 168, 1)
          : const Color.fromRGBO(25, 26, 25, 1),
    );
  }
}

TextStyle bodyLarge(BuildContext context) {
  if (BlocProvider.of<LanguageCubit>(context).isArabic) {
    return GoogleFonts.tajawal().copyWith(
      fontSize: 20 ,
      color: context.read<ThemeCubit>().isDark
          ? const Color.fromRGBO(216, 233, 168, 1)
          : const Color.fromRGBO(25, 26, 25, 1),
    );
  } else {
    return GoogleFonts.lato().copyWith(
      fontSize: 20 ,
      color: context.read<ThemeCubit>().isDark
          ? const Color.fromRGBO(216, 233, 168, 1)
          : const Color.fromRGBO(25, 26, 25, 1),
    );
  }
}

TextStyle bodyMedium(BuildContext context) {
  if (BlocProvider.of<LanguageCubit>(context).isArabic) {
    return GoogleFonts.tajawal().copyWith(
      fontSize: 18 ,
      color: context.read<ThemeCubit>().isDark
          ? const Color.fromRGBO(216, 233, 168, 1)
          : const Color.fromRGBO(25, 26, 25, 1),
    );
  } else {
    return GoogleFonts.lato().copyWith(
      fontSize: 18 ,
      color: context.read<ThemeCubit>().isDark
          ? const Color.fromRGBO(216, 233, 168, 1)
          : const Color.fromRGBO(25, 26, 25, 1),
    );
  }
}

TextStyle bodySmall(BuildContext context) {
  if (BlocProvider.of<LanguageCubit>(context).isArabic) {
    return GoogleFonts.tajawal().copyWith(
      fontSize: 16 ,
      color: context.read<ThemeCubit>().isDark
          ? const Color.fromRGBO(216, 233, 168, 1)
          : const Color.fromRGBO(25, 26, 25, 1),
    );
  } else {
    return GoogleFonts.lato().copyWith(
      fontSize: 16 ,
      color: context.read<ThemeCubit>().isDark
          ? const Color.fromRGBO(216, 233, 168, 1)
          : const Color.fromRGBO(25, 26, 25, 1),
    );
  }
}

TextStyle bodyVerSmall(BuildContext context) {
  if (BlocProvider.of<LanguageCubit>(context).isArabic) {
    return GoogleFonts.tajawal().copyWith(
      fontSize: 14 ,
      color: context.read<ThemeCubit>().isDark
          ? const Color.fromRGBO(216, 233, 168, 1)
          : const Color.fromRGBO(25, 26, 25, 1),
    );
  } else {
    return GoogleFonts.lato().copyWith(
      fontSize: 14 ,
      color: context.read<ThemeCubit>().isDark
          ? const Color.fromRGBO(216, 233, 168, 1)
          : const Color.fromRGBO(25, 26, 25, 1),
    );
  }
}

