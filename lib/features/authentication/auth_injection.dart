import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dalily/config/super_injection_container.dart';
import 'package:dalily/features/authentication/data/repository/auth_repo_imp.dart';
import 'package:dalily/features/authentication/data/resources/remote_data.dart';
import 'package:dalily/features/authentication/domain/repository/auth_repository.dart';
import 'package:dalily/features/authentication/domain/usecases/login.dart';
import 'package:dalily/features/authentication/domain/usecases/logout.dart';
import 'package:dalily/features/authentication/domain/usecases/send_otp.dart';
import 'package:dalily/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';

authInjectionContainer() {
  serverLocator.registerFactory(
    () => AuthenticationCubit(
      sendOtpUseCase: serverLocator(),
      loginUseCase: serverLocator(),
      logOutUseCase: serverLocator()
    ),
  );

  serverLocator.registerLazySingleton(() => SendOtpUseCase(authRepository: serverLocator()));
  serverLocator.registerLazySingleton(() => LoginUseCase(authRepository: serverLocator()));
  serverLocator.registerLazySingleton(() => LogOutUseCase(authRepository: serverLocator()));

  serverLocator.registerLazySingleton<AuthRepository>(() => AuthRepoImpl(authRemoteData: serverLocator()));

  serverLocator.registerLazySingleton<AuthRemoteData>(() => AuthRemoteDataImpl());

  serverLocator.registerLazySingleton(() => FirebaseAuth.instance);
  serverLocator.registerLazySingleton(() => FirebaseFirestore.instance);
}
