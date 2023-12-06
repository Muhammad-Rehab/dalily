import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dalily/core/helper/dialog.dart';
import 'package:dalily/core/helper/image_helper.dart';
import 'package:dalily/core/util/styles.dart';
import 'package:dalily/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:dalily/features/authentication/presentation/cubit/authentications_state.dart';
import 'package:dalily/features/authentication/presentation/screans/main_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LogInOrOutRecord extends StatefulWidget {

  LogInOrOutRecord({Key? key,}) : super(key: key);

  @override
  State<LogInOrOutRecord> createState() => _LogInOrOutRecordState();
}

class _LogInOrOutRecordState extends State<LogInOrOutRecord> {
  late bool isLogOut ;

  @override
  Widget build(BuildContext context) {
    isLogOut = FirebaseAuth.instance.currentUser == null ? false : true ;
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthExceptionState) {
          showCustomDialog(
            context: context,
            dialogType: DialogType.error,
            description: state.message,
          );
        }else if (state is UserLoggedOutState){
          setState(() {
            isLogOut = false ;
          });
        }
      },
      builder: (context, state) {
        return InkWell(
          onTap: (){
            if(isLogOut){
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
            }else {
              BlocProvider.of<AuthenticationCubit>(context).initAuthCubit(InitialAuthenticationState());
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainAuthScreen()));
            }

          },
          child: Container(
            margin: EdgeInsets.symmetric(
              vertical: isLogOut ? 10 : 20,
              horizontal: 5
            ),
            child: Row(
              children: [
                Text(
                  isLogOut ? AppLocalizations.of(context)!.log_out : AppLocalizations.of(context)!.register_as_service_owner,
                  style: bodySmall(context).copyWith(fontWeight: FontWeight.bold,
                  ),
                ),
                if(!isLogOut)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    width: 22,
                    height: 22,
                    child: Image.asset(ImageHelper.starIcon),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
