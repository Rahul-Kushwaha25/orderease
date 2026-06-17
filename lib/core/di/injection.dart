import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:orderease/core/database/db_helper.dart';
import 'package:orderease/core/localization/locale_cubit.dart';
import 'package:orderease/core/theme/theme_cubit.dart';
import 'package:orderease/core/router/app_router.dart';
import 'package:orderease/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:orderease/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:orderease/features/auth/domain/repositories/auth_repository.dart';
import 'package:orderease/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:orderease/features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:orderease/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:orderease/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:orderease/features/catalog/data/datasources/item_local_datasource.dart';
import 'package:orderease/features/catalog/data/repositories/item_repository_impl.dart';
import 'package:orderease/features/catalog/domain/repositories/item_repository.dart';
import 'package:orderease/features/catalog/domain/usecases/add_item_usecase.dart';
import 'package:orderease/features/catalog/domain/usecases/delete_item_usecase.dart';
import 'package:orderease/features/catalog/domain/usecases/get_items_usecase.dart';
import 'package:orderease/features/catalog/domain/usecases/update_item_usecase.dart';
import 'package:orderease/features/catalog/presentation/bloc/catalog_bloc.dart';
import 'package:orderease/features/home/presentation/bloc/home_bloc.dart';
import 'package:orderease/features/order/data/datasources/order_local_datasource.dart';
import 'package:orderease/features/order/data/repositories/order_repository_impl.dart';
import 'package:orderease/features/order/domain/repositories/order_repository.dart';
import 'package:orderease/features/order/domain/usecases/delete_expired_orders_usecase.dart';
import 'package:orderease/features/order/domain/usecases/get_recent_orders_usecase.dart';
import 'package:orderease/features/order/domain/usecases/save_order_usecase.dart';
import 'package:orderease/features/order/presentation/bloc/order_bloc.dart';
import 'package:orderease/features/profile/data/datasources/profile_local_datasource.dart';
import 'package:orderease/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:orderease/features/profile/domain/repositories/profile_repository.dart';
import 'package:orderease/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:orderease/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:orderease/features/profile/presentation/bloc/profile_bloc.dart';

final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {
  // 1. Third-party packages
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn());

  // 2. Core database & state helpers
  sl.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper.instance);
  sl.registerLazySingleton<LocaleCubit>(() => LocaleCubit());
  sl.registerLazySingleton<ThemeCubit>(() => ThemeCubit());

  // 3. Local Data Sources
  sl.registerLazySingleton<ProfileLocalDataSource>(() => ProfileLocalDataSource());
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl<FirebaseAuth>(), sl<GoogleSignIn>()),
  );
  sl.registerLazySingleton<ItemLocalDataSource>(() => ItemLocalDataSource(sl<DatabaseHelper>()));
  sl.registerLazySingleton<OrderLocalDataSource>(() => OrderLocalDataSource(sl<DatabaseHelper>()));

  // 4. Repositories
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(sl<ProfileLocalDataSource>()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthRemoteDataSource>()),
  );
  sl.registerLazySingleton<ItemRepository>(
    () => ItemRepositoryImpl(sl<ItemLocalDataSource>()),
  );
  sl.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(sl<OrderLocalDataSource>()),
  );

  // 5. Use Cases
  sl.registerFactory<GetProfileUseCase>(() => GetProfileUseCase(sl<ProfileRepository>()));
  sl.registerFactory<UpdateProfileUseCase>(() => UpdateProfileUseCase(sl<ProfileRepository>()));
  
  sl.registerFactory<GetCurrentUserUseCase>(() => GetCurrentUserUseCase(sl<AuthRepository>()));
  sl.registerFactory<SignInWithGoogleUseCase>(() => SignInWithGoogleUseCase(sl<AuthRepository>()));
  sl.registerFactory<SignOutUseCase>(() => SignOutUseCase(sl<AuthRepository>()));

  sl.registerFactory<AddItemUseCase>(() => AddItemUseCase(sl<ItemRepository>()));
  sl.registerFactory<DeleteItemUseCase>(() => DeleteItemUseCase(sl<ItemRepository>()));
  sl.registerFactory<GetItemsUseCase>(() => GetItemsUseCase(sl<ItemRepository>()));
  sl.registerFactory<UpdateItemUseCase>(() => UpdateItemUseCase(sl<ItemRepository>()));

  sl.registerFactory<DeleteExpiredOrdersUseCase>(() => DeleteExpiredOrdersUseCase(sl<OrderRepository>()));
  sl.registerFactory<GetRecentOrdersUseCase>(() => GetRecentOrdersUseCase(sl<OrderRepository>()));
  sl.registerFactory<SaveOrderUseCase>(() => SaveOrderUseCase(sl<OrderRepository>()));

  // 6. Blocs / Cubits
  sl.registerFactory<CatalogBloc>(
    () => CatalogBloc(
      getItemsUseCase: sl<GetItemsUseCase>(),
      addItemUseCase: sl<AddItemUseCase>(),
      updateItemUseCase: sl<UpdateItemUseCase>(),
      deleteItemUseCase: sl<DeleteItemUseCase>(),
    ),
  );
  sl.registerLazySingleton<AuthBloc>(
    () => AuthBloc(
      repository: sl<AuthRepository>(),
      signInUseCase: sl<SignInWithGoogleUseCase>(),
      signOutUseCase: sl<SignOutUseCase>(),
    ),
  );
  sl.registerFactory<HomeBloc>(
    () => HomeBloc(getItemsUseCase: sl<GetItemsUseCase>()),
  );
  sl.registerFactory<ProfileBloc>(
    () => ProfileBloc(
      getProfileUseCase: sl<GetProfileUseCase>(),
      updateProfileUseCase: sl<UpdateProfileUseCase>(),
    ),
  );
  sl.registerFactory<OrderBloc>(
    () => OrderBloc(
      saveOrderUseCase: sl<SaveOrderUseCase>(),
      getRecentOrdersUseCase: sl<GetRecentOrdersUseCase>(),
    ),
  );

  // 7. App Router (singleton that takes AuthBloc as constructor param)
  sl.registerSingleton<AppRouter>(AppRouter(sl<AuthBloc>()));
}
