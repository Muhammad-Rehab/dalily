import 'package:dalily/core/util/styles.dart';
import 'package:dalily/features/authentication/presentation/screans/signup.dart';
import 'package:dalily/features/language/presentation/cubit/language_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final GlobalKey _formKey = GlobalKey<FormState>();

  String phoneNumber = '';
  String otp = '';
  bool isCodeSend = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        alignment: Alignment.center,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.app_name,
                style: displayLarge(context).merge(GoogleFonts.kufam()).copyWith(fontSize: 60),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                AppLocalizations.of(context)!.welcome,
                style: titleSmall(context),
              ),
              const SizedBox(
                height: 50,
              ),
              Text(
                  "-------  ${AppLocalizations.of(context)!.login}   -------",
                style: titleSmall(context),
              ),
              const SizedBox(
                height: 50,
              ),
              if (!isCodeSend)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 50),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  height: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary.withOpacity(.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextFormField(
                    textDirection: TextDirection.ltr,
                    style: bodySmall(context),
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: AppLocalizations.of(context)!.phone_number,
                      hintStyle: bodySmall(context),
                      suffixText: BlocProvider.of<LanguageCubit>(context).isArabic ? ' 2+' : null,
                      prefixText: !BlocProvider.of<LanguageCubit>(context).isArabic ? '+2 ' : null,
                      prefixStyle: bodySmall(context).copyWith(fontWeight: FontWeight.bold),
                      suffixStyle: bodySmall(context).copyWith(fontWeight: FontWeight.bold),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.empty_phone_number;
                      } else if (value.length != 11) {
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
              if (isCodeSend)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 50),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  height: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary.withOpacity(.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextFormField(
                    textDirection: TextDirection.ltr,
                    style: bodySmall(context),
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: AppLocalizations.of(context)!.otp,
                      hintStyle: bodySmall(context),
                      suffixText: '  ',
                      prefixText: '  ',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length != 6) {
                        return AppLocalizations.of(context)!.otp_wrong_format;
                      }
                    },
                    onSaved: (value) {
                      otp = value!;
                    },
                  ),
                ),
              const SizedBox(
                height: 50,
              ),
              Container(
                width: double.infinity,
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 50),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      AppLocalizations.of(context)!.login,
                      style: titleSmall(context).copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 50),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue.shade900.withOpacity(.7)),
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>SignUpScreen()));
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
    );
  }
}
