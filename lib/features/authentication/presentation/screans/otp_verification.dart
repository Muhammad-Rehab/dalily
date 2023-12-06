import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dalily/config/routes.dart';
import 'package:dalily/core/cubit/timer/timer_cubit.dart';
import 'package:dalily/core/cubit/timer/timer_state.dart';
import 'package:dalily/core/helper/dialog.dart';
import 'package:dalily/core/util/app_strings.dart';
import 'package:dalily/core/util/styles.dart';
import 'package:dalily/features/authentication/data/model/service_owner_model.dart';
import 'package:dalily/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:dalily/features/authentication/presentation/cubit/authentications_state.dart';
import 'package:dalily/features/authentication/presentation/widgets/auth_header_widget.dart';
import 'package:dalily/features/notification/presentation/cubit/notification_cubit.dart';
import 'package:dalily/features/service_owners/data/model/servic_woner_state_model.dart';
import 'package:dalily/features/service_owners/prensentation/cubit/service_owner_state_cubit.dart';
import 'package:dalily/features/service_owners/prensentation/cubit/service_owner_state_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OtpVerificationScreen extends StatefulWidget {
  ServiceOwnerModel? serviceOwnerModel;
  bool fromRegister;

  String? phoneNumber;

  OtpVerificationScreen({Key? key, this.fromRegister = false, this.serviceOwnerModel, this.phoneNumber}) : super(key: key);

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  String otp = '';

  final GlobalKey _formKey = GlobalKey<FormState>();
  bool isResendOtp = true;

  listenToCode() async {
    await SmsAutoFill().listenForCode();
  }

  startPeriodicTimer(){
    BlocProvider.of<TimerCubit>(context).startPeriodicTimer(seconds: 60);
  }

  getAppToken(){
    BlocProvider.of<NotificationCubit>(context).getAppToken();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      listenToCode();
      startPeriodicTimer();
      getAppToken();
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
                  onCodeChanged: (val) {
                    otp = val ?? '';
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
              BlocListener<ServiceOwnerStateCubit, ServiceOwnerStateStates>(
                listener: (context, state) {
                  if (state is LoadedSingleOwnerState) {
                    if (state.serviceOwnerStateModel.state == AppStrings.waitingState) {
                      showCustomDialog(
                          context: context,
                          dialogType: DialogType.warning,
                          description: AppLocalizations.of(context)!.waiting_state_disc,
                          okText: AppLocalizations.of(context)!.ok,
                          onOK: () {
                            BlocProvider.of<AuthenticationCubit>(context).initAuthCubit(InitialAuthenticationState());
                            Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.initialRoute, (route) => false);
                          });
                    } else if (state.serviceOwnerStateModel.state == AppStrings.rejectedState) {
                      showCustomDialog(
                          context: context,
                          dialogType: DialogType.warning,
                          title: AppLocalizations.of(context)!.rejected_state_title,
                          description: state.serviceOwnerStateModel.description,
                          okText: AppLocalizations.of(context)!.signup,
                          onOK: () {
                            BlocProvider.of<AuthenticationCubit>(context).initAuthCubit(RegisterScreenState());
                            Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.mainAuthRoute, (route) => false);
                          });
                    } else {
                      BlocProvider.of<ServiceOwnerStateCubit>(context).serviceOwnerModel = state.serviceOwnerStateModel.serviceOwnerModel;
                      Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.initialRoute, (route) => false);
                    }
                  } else if (state is ServiceOwnerStateError) {
                    if (state.message != null) {
                      showCustomDialog(
                          context: context,
                          dialogType: DialogType.warning,
                          description: state.message,
                          okText: AppLocalizations.of(context)!.signup,
                          onOK: () {
                            BlocProvider.of<AuthenticationCubit>(context).initAuthCubit(RegisterScreenState());
                          });
                    } else {
                      showCustomDialog(
                          context: context, dialogType: DialogType.error, description: AppLocalizations.of(context)!.internet_connection_error);
                    }
                  }
                },
                child: BlocConsumer<AuthenticationCubit, AuthenticationState>(
                  listener: (ctx, authState) {
                    if (authState is AuthLoggedInState && widget.fromRegister) {
                      widget.serviceOwnerModel!.id = authState.id;
                      Map<String, dynamic> data = {
                        'id': authState.id,
                        'state': AppStrings.waitingState,
                        'app_token': BlocProvider.of<NotificationCubit>(context).appToken,
                        'service_owner_model': jsonEncode(widget.serviceOwnerModel!.toJson()),
                      };
                      BlocProvider.of<ServiceOwnerStateCubit>(context).addServiceOwnerModel(ServiceOwnerStateModel.fromJson(data));
                      showCustomDialog(
                          context: context,
                          dialogType: DialogType.success,
                          description: AppLocalizations.of(context)!.sign_up_success,
                          okText: AppLocalizations.of(context)!.ok,
                          onOK: () {
                            BlocProvider.of<AuthenticationCubit>(context).initAuthCubit(RegisterScreenState());
                            Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.initialRoute, (route) => false);
                          });
                    } else if (authState is AuthLoggedInState && !widget.fromRegister) {
                      BlocProvider.of<ServiceOwnerStateCubit>(context).getSingleOwner(authState.id, context);
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
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              BlocBuilder<TimerCubit, TimerSate>(builder: (context, state) {
                if (state is OnPeriodicTimerState) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 55),
                    alignment: Alignment.center,
                    child: SafeArea(
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: AppLocalizations.of(context)!.resend_otp_after,
                              style: bodyVerSmall(context).copyWith(fontWeight: FontWeight.bold)),
                          TextSpan(text: '  ${60 - state.timer.tick}  ', style: bodyVerSmall(context).copyWith(fontWeight: FontWeight.bold)),
                          TextSpan(text: AppLocalizations.of(context)!.second, style: bodyVerSmall(context).copyWith(fontWeight: FontWeight.bold)),
                        ]),
                      ),
                    ),
                  );
                } else if (state is PeriodicTimerCanceled) {
                  return isResendOtp
                      ? Container(
                          margin: const EdgeInsets.symmetric(horizontal: 55),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isResendOtp = false;
                              });
                              if (widget.fromRegister) {
                                context.read<AuthenticationCubit>().sendOtp(
                                      widget.phoneNumber!,
                                      context,
                                      serviceOwnerModel: widget.serviceOwnerModel,
                                      fromRegister: widget.fromRegister,
                                    );
                              } else {
                                context.read<AuthenticationCubit>().sendOtp(widget.phoneNumber!, context);
                              }
                            },
                            child: Text(
                              AppLocalizations.of(context)!.resend_otp,
                              style: titleSmall(context),
                            ),
                          ),
                        )
                      : Container();
                } else {
                  return Container();
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
