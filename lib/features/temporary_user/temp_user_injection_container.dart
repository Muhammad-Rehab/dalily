import 'package:dalily/config/super_injection_container.dart';
import 'package:dalily/features/temporary_user/data/data_resource/local_data_resource.dart';
import 'package:dalily/features/temporary_user/data/data_resource/remote_data_resource.dart';
import 'package:dalily/features/temporary_user/data/repository/temp_user_repo_imp.dart';
import 'package:dalily/features/temporary_user/domain/repository/temp_user_repo.dart';
import 'package:dalily/features/temporary_user/domain/usecase/add_temp_user_use_case.dart';
import 'package:dalily/features/temporary_user/domain/usecase/add_to_chat_use_case.dart';
import 'package:dalily/features/temporary_user/domain/usecase/get_temp_user_usecase.dart';
import 'package:dalily/features/temporary_user/presentation/cubit/temp_user_cubit.dart';

tempUserInjectionContainer() {
  serverLocator.registerFactory(
    () => TempUserCubit(
      addTempUserUseCase: serverLocator(),
      getTempUserUseCase: serverLocator(),
      addToChatListUseCase: serverLocator(),
    ),
  );

  serverLocator.registerLazySingleton(() => AddTempUserUseCase(tempUserRepository: serverLocator()));
  serverLocator.registerLazySingleton(() => GetTempUserUseCase(tempUserRepository: serverLocator()));
  serverLocator.registerLazySingleton(() => AddToChatListUseCase(tempUserRepository: serverLocator()));

  serverLocator.registerLazySingleton<TempUserRepository>(
    () => TempUserRepoImp(
      tempUserRemoteResource: serverLocator(),
      tempUserLocalResource: serverLocator(),
    ),
  );
  serverLocator.registerLazySingleton<TempUserRemoteResource>(
    () => TempUserRemoteResourceImp(
      firebaseFirestore: serverLocator(),
      firebaseStorage: serverLocator(),
    ),
  );
  serverLocator.registerLazySingleton<TempUserLocalResource>(() => TempUserLocalResourceImp(sharedPreferences: serverLocator()));
}
