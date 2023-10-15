import 'package:dalily/features/app_theme/presentation/cubit/theme_cubit.dart';
import 'package:dalily/features/app_theme/presentation/cubit/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ThemeRecord extends StatelessWidget {

  ThemeRecord({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppLocalizations.of(context)!.dark_them,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          Switch(
            value: BlocProvider.of<ThemeCubit>(context,).isDark!,
            onChanged: (val){
              BlocProvider.of<ThemeCubit>(context).toggleTheme();
            },
          ),
        ],
      ),
    );
  }
}
