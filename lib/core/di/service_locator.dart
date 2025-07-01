import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../features/Auth/data/repos/auth_repo.dart';
import '../../features/Auth/data/repos/auth_repo_impl.dart';
import '../../features/Auth/presentation/manger/auth_cubit/auth_cubit.dart';
import '../../features/home/presentation/manager/cubits/recent_uploads_cubit.dart';
import '../../features/profile/data/repos/user_profile_repo.dart';
import '../../features/profile/data/repos/user_profile_repo_impl.dart';
import '../../features/profile/presentation/manager/user_profile_cubit/update_profile_cubit.dart';
import '../../features/profile/presentation/manager/user_profile_cubit/logout_cubit.dart';
import '../../features/profile/presentation/manager/user_profile_cubit/delete_account_cubit.dart';
import '../../features/profile/presentation/manager/user_profile_cubit/get_user_cubit.dart';
import '../helpers/database/cache_helper.dart';
import '../helpers/database/user_cache_helper.dart';
import '../networking/api_consumer.dart';
import '../networking/dio_consumer.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // Core - Initialize cache helpers first
  getIt.registerLazySingleton<CacheHelper>(() => CacheHelper());
  getIt.registerLazySingleton<UserCacheHelper>(() => UserCacheHelper());

  // Initialize cache helpers
  await getIt<CacheHelper>().init();
  await getIt<UserCacheHelper>().init();

  // Networking - Create after cache helpers are initialized
  getIt.registerLazySingleton<Dio>(() => Dio());
  getIt.registerLazySingleton<ApiConsumer>(
    () => DioConsumer(dio: getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(
      getIt<UserCacheHelper>(),
      apiConsumer: getIt(),
    ),
  );
  getIt.registerLazySingleton<UserProfileRepo>(
    () => UserProfileRepoImpl(
      apiConsumer: getIt(),
      userCacheHelper: getIt(),
    ),
  );

  // cubits
  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(getIt<AuthRepo>()),
  );
  getIt.registerFactory<RecentUploadsCubit>(
    () => RecentUploadsCubit(),
  );
  getIt.registerFactory<UpdateProfileCubit>(
    () =>
        UpdateProfileCubit(getIt<UserProfileRepo>(), getIt<UserCacheHelper>()),
  );
  getIt.registerFactory<LogoutCubit>(
    () => LogoutCubit(getIt<UserProfileRepo>(), getIt<UserCacheHelper>()),
  );
  getIt.registerFactory<DeleteAccountCubit>(
    () =>
        DeleteAccountCubit(getIt<UserProfileRepo>(), getIt<UserCacheHelper>()),
  );
  getIt.registerFactory<GetUserCubit>(
    () => GetUserCubit(getIt<UserProfileRepo>(), getIt<UserCacheHelper>()),
  );
}
