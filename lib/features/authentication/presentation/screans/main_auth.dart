
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dalily/core/helper/dialog.dart';
import 'package:dalily/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:dalily/features/authentication/presentation/cubit/authentications_state.dart';
import 'package:dalily/features/authentication/presentation/screans/login.dart';
import 'package:dalily/features/authentication/presentation/screans/otp_verification.dart';
import 'package:dalily/features/authentication/presentation/screans/signup.dart';
import 'package:dalily/main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainAuthScreen extends StatelessWidget {
   MainAuthScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthenticationCubit,AuthenticationState>(
        buildWhen: (previousState,currentStat){
          return (currentStat is CodeIsSendState || currentStat is RegisterScreenState || currentStat is InitialAuthenticationState);
        },
        listener: (context,state){
          if (state is AuthExceptionState) {
            Future.delayed(const Duration(seconds: 0),(){
              showCustomDialog(
                context: context,
                dialogType: DialogType.error,
                description: state.message,
                okText: AppLocalizations.of(context)!.ok,
                onOK: () {
                  // Navigator.pop(context);
                },
              );
            });
          }
        },
        builder: (context,state){
          if (state is CodeIsSendState || state is IsLoggingInState){
            if(state is CodeIsSendState){
              return OtpVerificationScreen(phoneNumber: state.phoneNumber,
                serviceOwnerModel: state.serviceOwnerModel,fromRegister: state
                  .fromRegister,);
            }
            return OtpVerificationScreen();
          }else if (state is RegisterScreenState){
            return SignUpScreen();
          }else {
            return LoginScreen();
          }
        },

      ),
    );
  }
}
