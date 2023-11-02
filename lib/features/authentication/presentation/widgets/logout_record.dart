import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dalily/core/helper/dialog.dart';
import 'package:dalily/core/util/styles.dart';
import 'package:dalily/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:dalily/features/authentication/presentation/cubit/authentications_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LogOutRecord extends StatelessWidget {
  const LogOutRecord({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthExceptionState) {
          showCustomDialog(
            context: context,
            dialogType: DialogType.error,
            description: state.message,
          );
        }
      },
      builder: (context, state) {
        return InkWell(
          onTap: (){
            showCustomDialog(
              context: context,
              title: AppLocalizations.of(context)!.log_out,
              description: AppLocalizations.of(context)!.log_out_question,
              dialogType: DialogType.info,
              onOK: () {
                BlocProvider.of<AuthenticationCubit>(context).logOut(context);
              },
              okText: AppLocalizations.of(context)!.ok,
              onCancel: () {},
              cancelText: AppLocalizations.of(context)!.cancel,
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 5
            ),
            child: Text(
              AppLocalizations.of(context)!.log_out,
              style: bodySmall(context).copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }
}
