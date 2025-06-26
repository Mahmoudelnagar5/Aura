import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../features/Auth/data/repos/auth_repo.dart';
import '../../features/Auth/data/repos/auth_repo_impl.dart';
import '../../features/Auth/presentation/manger/auth_cubit/auth_cubit.dart';
import '../helpers/database/cache_helper.dart';
import '../networking/api_consumer.dart';
import '../networking/dio_consumer.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // Core
  getIt.registerLazySingleton<CacheHelper>(() => CacheHelper());

  // Initialize cache helper
  await getIt<CacheHelper>().init();

  // Networking
  getIt.registerLazySingleton<Dio>(() => Dio());
  getIt.registerLazySingleton<ApiConsumer>(
    () => DioConsumer(dio: getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(
      apiConsumer: getIt(),
      cacheHelper: getIt(),
    ),
  );

  // cubits
  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(getIt<AuthRepo>()),
  );
}
