import 'package:dalily/core/util/styles.dart';
import 'package:dalily/features/theme/presentation/cubit/theme_cubit.dart';
import 'package:dalily/features/theme/presentation/cubit/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ThemeRecord extends StatelessWidget {

  const ThemeRecord({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: BlocBuilder<ThemeCubit,ThemeState>(
        builder: (context,state)=>Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.dark_them,
              style: bodyMedium(context).copyWith(fontWeight: FontWeight.bold),
            ),
            Switch(
              value: BlocProvider.of<ThemeCubit>(context,).isDark,
              onChanged: (val){
                BlocProvider.of<ThemeCubit>(context).toggleTheme();
              },
            ),
          ],
        ),
      ),
    );
  }
}
