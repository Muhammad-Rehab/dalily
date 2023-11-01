import 'dart:async';

import 'package:dalily/core/error/firebase_auth_exception.dart';
import 'package:dalily/core/util/app_strings.dart';
import 'package:dalily/features/authentication/data/model/service_owner_model.dart';
import 'package:dalily/features/authentication/domain/usecases/login.dart';
import 'package:dalily/features/authentication/domain/usecases/send_otp.dart';
import 'package:dalily/features/authentication/presentation/cubit/authentications_state.dart';
import 'package:dalily/features/items/data/model/ItemModel.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  SendOtpUseCase sendOtpUseCase;
  LoginUseCase loginUseCase;
  Timer? _timer;

  AuthenticationCubit({required this.sendOtpUseCase, required this.loginUseCase}) : super(InitialAuthenticationState());

  logIn(String otp, BuildContext context) async {
    emit(IsLoggingInState());
    Either<AppFirebaseAuthException, String> response = await loginUseCase.call(otp);
    emit(
      response.fold(
        (authException) => getAuthExceptionMessage(authException, context),
        (id) => AuthLoggedInState(id: id),
      ),
    );
    cancelTimer();
  }

  Future<void> sendOtp(String phoneNumber, BuildContext context,
      {ServiceOwnerModel? serviceOwnerModel, bool fromRegister = false, bool stopTimer = false, ItemModel? itemModel}) async {
    emit(IsSendingOtpState());
    Either<AppFirebaseAuthException, Stream<String>> response = await sendOtpUseCase.call(phoneNumber);
    emit(response.fold((authException) {
      return getAuthExceptionMessage(authException, context);
    }, (right) {
      right.listen((event) {
        if (event == AppStrings.trueString) {
          emit(
            CodeIsSendState(phoneNumber: phoneNumber, serviceOwnerModel: serviceOwnerModel, fromRegister: fromRegister, itemModel: itemModel),
          );
          if (!stopTimer) {
            startTimer();
          }
        } else {
          emit(getAuthExceptionMessage(null, context, errorMessage: event));
        }
      });
      return IsSendingOtpState();
    }));
  }

  AuthenticationState getAuthExceptionMessage(AppFirebaseAuthException? authException, BuildContext context, {String errorMessage = ''}) {
    if (authException is InvalidPhoneNumber || errorMessage == AppStrings.invalidPhoneNumberError) {
      return AuthExceptionState(message: AppLocalizations.of(context)!.invalid_phone_number);
    } else if (authException is PhoneAlreadyExist || errorMessage == AppStrings.phoneAlreadyExistError) {
      return AuthExceptionState(message: AppLocalizations.of(context)!.phone_already_exist);
    } else if (authException is TooManyRequests || errorMessage == AppStrings.tooManyRequestError) {
      return AuthExceptionState(message: AppLocalizations.of(context)!.too_many_request);
    } else if (authException is InvalidOtpCode || errorMessage == AppStrings.invalidOtpCod) {
      return AuthExceptionState(message: AppLocalizations.of(context)!.invalid_otp_code);
    } else {
      return AuthExceptionState(message: AppLocalizations.of(context)!.other_auth_error);
    }
  }

  initAuthCubit(AuthenticationState authenticationState) {
    emit(authenticationState);
  }

  startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timer.tick == 60) {
        emit(SecondPassed());
        emit(Timing(seconds: 0));
        timer.cancel();
      } else {
        emit(SecondPassed());
        emit(Timing(seconds: timer.tick));
      }
    });
  }

  cancelTimer() {
    _timer!.cancel();
  }
}
