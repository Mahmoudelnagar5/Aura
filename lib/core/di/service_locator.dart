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
import '../../features/summary/data/repos/summary_repo.dart';
import '../../features/summary/data/repos/summary_repo_impl.dart';
import '../../features/summary/presentation/manger/summary_cubit/summary_cubit.dart';
import '../helpers/database/user_cache_helper.dart';
import '../networking/api_consumer.dart';
import '../networking/dio_consumer.dart';
import '../../features/home/data/repos/upload_repo_impl.dart';
import '../../features/home/data/repos/uploads_repo.dart';
import '../helpers/database/cache_helper.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // Register CacheHelper for theme and other shared preferences usage
  getIt.registerLazySingleton<CacheHelper>(() => CacheHelper());
  // Initialize CacheHelper
  await getIt<CacheHelper>().init();
  // Core - Initialize cache helpers first
  getIt.registerLazySingleton<UserCacheHelper>(() => UserCacheHelper());

  // Initialize cache helpers
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
  getIt.registerLazySingleton<SummaryRepo>(
    () => SummaryRepoImpl(),
  );
  getIt.registerLazySingleton<UploadsRepo>(
    () => UploadRepoImpl(apiConsumer: getIt()),
  );

  // cubits
  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(getIt<AuthRepo>()),
  );
  getIt.registerFactory<RecentUploadsCubit>(
    () => RecentUploadsCubit(uploadsRepo: getIt<UploadsRepo>()),
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
  getIt.registerFactory<SummaryCubit>(() => SummaryCubit(getIt<SummaryRepo>()));
}
