import 'package:dalily/config/super_injection_container.dart';
import 'package:dalily/features/service_owners/data/data_resource/remote_data_source.dart';
import 'package:dalily/features/service_owners/data/repository/service_owner_state_repo_imp.dart';
import 'package:dalily/features/service_owners/domain/repository/service_owner_state_repository.dart';
import 'package:dalily/features/service_owners/domain/use_cases/add_service_owner_state.dart';
import 'package:dalily/features/service_owners/domain/use_cases/get_current_user_data.dart';
import 'package:dalily/features/service_owners/domain/use_cases/get_single_service_owner.dart';
import 'package:dalily/features/service_owners/domain/use_cases/get_waiting_list.dart';
import 'package:dalily/features/service_owners/domain/use_cases/update_server_state.dart';
import 'package:dalily/features/service_owners/prensentation/cubit/service_owner_state_cubit.dart';

serviceOwnersInjectionContaier() {
  serverLocator.registerFactory(
    () => ServiceOwnerStateCubit(
      getSingleServiceOwnerUseCase: serverLocator(),
      addServiceOwnerStateUseCase: serverLocator(),
      updateServerStateListUseCase: serverLocator(),
      getServersWaitingListUseCase: serverLocator(),
      getCurrentUserDataUseCase: serverLocator(),
    ),
  );

  serverLocator.registerLazySingleton(() => GetSingleServiceOwnerUseCase(serviceOwnerStateRepository: serverLocator()));
  serverLocator.registerLazySingleton(() => AddServiceOwnerStateUseCase(serviceOwnerStateRepository: serverLocator()));
  serverLocator.registerLazySingleton(() => UpdateServerStateListUseCase(serviceOwnerStateRepository: serverLocator()));
  serverLocator.registerLazySingleton(() => GetServersWaitingListUseCase(serviceOwnerStateRepository: serverLocator()));
  serverLocator.registerLazySingleton(() => GetCurrentUserDataUseCase(serviceOwnerStateRepository: serverLocator()));

  serverLocator.registerLazySingleton<ServiceOwnerStateRepository>(() => ServiceOwnerStateRepoImp(serviceOwnerStateRemoteSource: serverLocator()));

  serverLocator.registerLazySingleton<ServiceOwnerStateRemoteSource>(() => ServiceOwnerStateRemoteSourceImp(firebaseFirestore: serverLocator(),
      storage: serverLocator()));


}

