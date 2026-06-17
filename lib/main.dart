import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderease/core/localization/l10n/app_localizations.dart';
import 'core/di/injection.dart';
import 'core/theme/theme_cubit.dart';
import 'core/theme/app_theme.dart';
import 'core/localization/locale_cubit.dart';
import 'core/router/app_router.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/catalog/presentation/bloc/catalog_bloc.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/order/presentation/bloc/order_bloc.dart';
import 'features/order/domain/usecases/delete_expired_orders_usecase.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';

// Dummy Localizations mapping for standalone compilation checks
// class AppLocalizations {
//   static const localizationsDelegates = [
//     GlobalMaterialLocalizations.delegate,
//     GlobalWidgetsLocalizations.delegate,
//     GlobalCupertinoLocalizations.delegate,
//   ];
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyC63kpSmko4uPixz50gmfXU2RpbCFZaFZ0",
      appId: "1:435477027051:android:a9b41d4aad7fa80a9746ae",
      messagingSenderId: "435477027051",
      projectId: "com.titan.orderease",
    ),
  );
  await configureDependencies();
  try {
    await sl<DeleteExpiredOrdersUseCase>()(); // cleanup on launch
  } catch (e) {
    debugPrint("Delete Expired Orders Error : $e");
  }
  runApp(const DukaanOrderApp());
}

class DukaanOrderApp extends StatelessWidget {
  const DukaanOrderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<ThemeCubit>()..loadTheme()),
        BlocProvider(create: (_) => sl<LocaleCubit>()..loadLocale()),
        BlocProvider(
          create: (_) => sl<AuthBloc>()..add(const CheckAuthStatus()),
          lazy: false,
        ),
        BlocProvider(create: (_) => sl<CatalogBloc>()),
        BlocProvider(create: (_) => sl<HomeBloc>()),
        BlocProvider(create: (_) => sl<OrderBloc>()),
        BlocProvider(create: (_) => sl<ProfileBloc>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return BlocBuilder<LocaleCubit, Locale>(
            builder: (context, locale) {
              return MaterialApp.router(
                title: 'orderease',
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
                themeMode: themeMode,
                locale: locale,
                supportedLocales: const [Locale('en'), Locale('hi')],
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                routerConfig: sl<AppRouter>().router,
              );
            },
          );
        },
      ),
    );
  }
}
