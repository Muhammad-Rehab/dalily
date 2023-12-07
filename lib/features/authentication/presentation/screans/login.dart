import 'package:dalily/config/routes.dart';
import 'package:dalily/core/util/styles.dart';
import 'package:dalily/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:dalily/features/authentication/presentation/cubit/authentications_state.dart';
import 'package:dalily/features/authentication/presentation/screans/signup.dart';
import 'package:dalily/features/authentication/presentation/widgets/auth_header_widget.dart';
import 'package:dalily/features/language/presentation/cubit/language_cubit.dart';
import 'package:dalily/features/theme/presentation/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String phoneNumber = '';

  sendOtp(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    } else {
      _formKey.currentState!.save();
      BlocProvider.of<AuthenticationCubit>(context).sendOtp(phoneNumber,context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, AppRoutes.categoryScreen, (route) => false);
            },
            icon: Icon(
              Icons.home_filled,
              color: BlocProvider.of<ThemeCubit>(context).isDark
                  ? Theme.of(context).colorScheme.surface
                  : Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 40, bottom: 20,left: 50,right: 50),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AuthHeaderWidget(pageTitle: AppLocalizations.of(context)!.login),
                        // phone number field
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary.withOpacity(.3),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: TextFormField(
                            textDirection: TextDirection.ltr,
                            style: bodySmall(context),
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              fillColor: Theme.of(context).colorScheme.secondary.withOpacity(.3),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                // borderSide: BorderSide(color:Theme.of(context).colorScheme.secondary.withOpacity(.3) )
                              ),
                              hintText: AppLocalizations.of(context)!.phone_number,
                              hintStyle: bodySmall(context),
                              suffixText: BlocProvider.of<LanguageCubit>(context).isArabic ? ' 2+' : null,
                              prefixText: !BlocProvider.of<LanguageCubit>(context).isArabic ? '+2 ' : null,
                              prefixStyle: bodySmall(context).copyWith(fontWeight: FontWeight.bold),
                              suffixStyle: bodySmall(context).copyWith(fontWeight: FontWeight.bold),
                              errorMaxLines: 2,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context)!.empty_phone_number;
                              } else if (value.replaceAll(' ', '').length != 11) {
                                return AppLocalizations.of(context)!.wrong_phone_number_length;
                              } else if (!value.startsWith('010') && !value.startsWith('011') && !value.startsWith('012') && !value.startsWith('015')) {
                                return AppLocalizations.of(context)!.wrong_phone_number_format;
                              }
                            },
                            onSaved: (value) {
                              phoneNumber = '+2$value';
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        // log in button
                        BlocBuilder<AuthenticationCubit,AuthenticationState>(
                          builder: (context,state) {
                            if(state is IsSendingOtpState){
                              return  const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        sendOtp(context);
                                      },
                                      child: Text(
                                        AppLocalizations.of(context)!.login,
                                        style: titleSmall(context).copyWith(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                );
                          }
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // sign up button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.blue.shade900.withOpacity(.7)),
                              ),
                              onPressed: () {
                                BlocProvider.of<AuthenticationCubit>(context).initAuthCubit(RegisterScreenState());
                                // Navigator.push(context, MaterialPageRoute(builder: (_) => SignUpScreen()));
                              },
                              child: Text(
                                AppLocalizations.of(context)!.signup,
                                style: titleSmall(context).copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
      ),
    );
  }
}
