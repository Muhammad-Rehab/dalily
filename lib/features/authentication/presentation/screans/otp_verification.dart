
import 'dart:convert';

import 'package:dalily/core/util/app_strings.dart';
import 'package:dalily/core/util/styles.dart';
import 'package:dalily/features/authentication/data/model/service_owner_model.dart';
import 'package:dalily/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:dalily/features/authentication/presentation/cubit/authentications_state.dart';
import 'package:dalily/features/authentication/presentation/widgets/auth_header_widget.dart';
import 'package:dalily/features/service_owners/data/model/servic_woner_state_model.dart';
import 'package:dalily/features/service_owners/prensentation/cubit/service_owner_state_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OtpVerificationScreen extends StatefulWidget {
  ServiceOwnerModel? serviceOwnerModel;
  bool fromRegister;

  String ? phoneNumber ;

  OtpVerificationScreen({Key? key, this.fromRegister = false, this.serviceOwnerModel,this.phoneNumber}) : super(key: key);

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  String otp = '';

  final GlobalKey _formKey = GlobalKey<FormState>();

  listenToCode() async {
    await SmsAutoFill().listenForCode();
  }



  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      listenToCode();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 100, bottom: 20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AuthHeaderWidget(pageTitle: AppLocalizations.of(context)!.verification_code),

              // otp field
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: PinFieldAutoFill(
                  codeLength: 6,
                  onCodeSubmitted: (val) {
                    otp = val;
                  },
                  onCodeChanged: (val){
                    otp = val??'';
                  },
                  decoration: BoxLooseDecoration(
                    strokeColorBuilder: FixedColorBuilder(
                      Theme.of(context).colorScheme.primary,
                    ),
                    bgColorBuilder: FixedColorBuilder(Theme.of(context).colorScheme.secondary.withOpacity(.2)),
                    textStyle: titleSmall(context),
                    radius: const Radius.circular(10),
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              // confirm entry button
              BlocConsumer<AuthenticationCubit, AuthenticationState>(
                listener: (ctx,state){
                  if(state is AuthLoggedInState && widget.fromRegister){
                    widget.serviceOwnerModel!.id = state.id;
                    Map<String,dynamic> data = {
                      'id': state.id,
                      'state': AppStrings.waitingState,
                      'service_owner_model': jsonEncode(widget.serviceOwnerModel!.toJson()),
                    };
                    BlocProvider.of<ServiceOwnerStateCubit>(context).addServiceOwnerModel(
                      ServiceOwnerStateModel.fromJson(data)
                    );
                  }
                },
                  builder: (context, state) {
                if (state is IsLoggingInState || state is IsSigningUpState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Container(
                  width: double.infinity,
                  height: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 50),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<AuthenticationCubit>().logIn(otp, context);
                      },
                      child: Text(
                        AppLocalizations.of(context)!.confirm_entry,
                        style: titleSmall(context).copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(
                height: 20,
              ),


              BlocBuilder<AuthenticationCubit,AuthenticationState>(
                  builder: (context ,state){
                  if(state is Timing && state.seconds != 0){
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 55),
                      alignment: Alignment.center,
                      child: SafeArea(
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: AppLocalizations.of(context)!.resend_otp_after,
                                style: bodyVerSmall(context).copyWith(fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: '  ${60 - state.seconds}  ',
                                style: bodyVerSmall(context).copyWith(fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: AppLocalizations.of(context)!.second, style: bodyVerSmall(context).copyWith(fontWeight: FontWeight.bold)),
                          ]),
                        ),
                      ),
                    );
                  }else if (state is Timing && state.seconds == 0){
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 55),
                      child: InkWell(
                        onTap: () {
                          if(widget.fromRegister){
                            context.read<AuthenticationCubit>().sendOtp(widget.phoneNumber!,context,
                                serviceOwnerModel: widget.serviceOwnerModel,fromRegister: widget.fromRegister,
                              stopTimer: true,
                            );
                          }else{
                            context.read<AuthenticationCubit>().sendOtp(widget.phoneNumber!,context,stopTimer: true);
                          }

                        },
                        child: Text(
                          AppLocalizations.of(context)!.resend_otp,
                          style: titleSmall(context),
                        ),
                      ),
                    );
                  }else {
                    return Container();
                  }
                }),


              // Container(
              //   width: double.infinity,
              //   height: 50,
              //   margin: const EdgeInsets.symmetric(horizontal: 50),
              //   child: ClipRRect(
              //     borderRadius: BorderRadius.circular(30),
              //     child: ElevatedButton(
              //       style: ButtonStyle(
              //         backgroundColor: MaterialStateProperty.all(Colors.blue.shade900.withOpacity(.7)),
              //       ),
              //       onPressed: () {
              //         Navigator.pop(context);
              //       },
              //       child: Text(
              //         AppLocalizations.of(context)!.signup,
              //         style: titleSmall(context).copyWith(color: Colors.white),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
