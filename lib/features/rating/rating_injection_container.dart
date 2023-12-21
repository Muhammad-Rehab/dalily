import 'package:dalily/config/super_injection_container.dart';
import 'package:dalily/features/rating/data/data_resource/remote_data_resource.dart';
import 'package:dalily/features/rating/data/rate_repo_imp/rate_repo_imp.dart';
import 'package:dalily/features/rating/domain/rate_repository/rate_repository.dart';
import 'package:dalily/features/rating/domain/use_cases/add_rate_use_case.dart';
import 'package:dalily/features/rating/presentation/cubit/rate_cubit.dart';

getRatingInjectionContainer() {
  serverLocator.registerFactory(() => RateCubit(addRateUseCase: serverLocator()));

  serverLocator.registerLazySingleton(() => AddRateUseCase(rateRepository: serverLocator()));

  serverLocator.registerLazySingleton<RateRepository>(() => RateRepoImp(rateRemoteDataResource: serverLocator()));

  serverLocator.registerLazySingleton<RateRemoteDataResource>(() => RateRemoteDataResourceImp(firebaseFirestore: serverLocator()));
}
