import 'package:dalily/config/routes.dart';
import 'package:dalily/config/super_injection_container.dart';
import 'package:dalily/config/theme.dart';
import 'package:dalily/core/cubit/timer/timer_cubit.dart';
import 'package:dalily/core/helper/block_observer.dart';
import 'package:dalily/core/helper/notification_helper.dart';
import 'package:dalily/features/authentication/auth_injection.dart';
import 'package:dalily/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:dalily/features/authentication/presentation/screans/main_auth.dart';
import 'package:dalily/features/categories/category_injection_container.dart';
import 'package:dalily/features/categories/presentation/cubit/category_cubit.dart';
import 'package:dalily/features/categories/presentation/screens/cat_screen_details.dart';
import 'package:dalily/features/categories/presentation/screens/category_screen.dart';
import 'package:dalily/core/screens/splash.dart';
import 'package:dalily/features/items/item_injection_container.dart';
import 'package:dalily/features/items/presentation/cubit/item_cubit.dart';
import 'package:dalily/features/notification/notification_injection_container.dart';
import 'package:dalily/features/notification/presentation/cubit/notification_cubit.dart';
import 'package:dalily/features/service_owners/prensentation/cubit/service_owner_state_cubit.dart';
import 'package:dalily/features/items/presentation/screens/items_screen.dart';
import 'package:dalily/features/language/data/model/language_model.dart';
import 'package:dalily/features/language/language_injection_container.dart';
import 'package:dalily/features/language/presentation/cubit/language_cubit.dart';
import 'package:dalily/features/language/presentation/cubit/language_state.dart';
import 'package:dalily/features/service_owners/service_owners_injection_container.dart';
import 'package:dalily/features/temporary_user/presentation/cubit/temp_user_cubit.dart';
import 'package:dalily/features/temporary_user/presentation/screens/add_temp_user_screen.dart';
import 'package:dalily/features/temporary_user/presentation/screens/temp_user_profile.dart';
import 'package:dalily/features/temporary_user/temp_user_injection_container.dart';
import 'package:dalily/features/theme/data/model/app_theme_model.dart';
import 'package:dalily/features/theme/presentation/cubit/theme_cubit.dart';
import 'package:dalily/features/theme/presentation/cubit/theme_state.dart';
import 'package:dalily/features/theme/theme_injection_container.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

getInjectionContainers() async {
  await superInjectionContainer();
  themeInjectionContainer();
  languageInjectionContainer();
  authInjectionContainer();
  categoryInjectionContainer();
  getItemInjectionContainer();
  serviceOwnersInjectionContaier();
  tempUserInjectionContainer();
  notificationInjectionContainer();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await getInjectionContainers();
  Bloc.observer = LoggingBlocObserver();
  NotificationHelper.requestNotificationPermissions();
  NotificationHelper.handleIfNotificationAction();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  final String? route;

  const MyApp({super.key, this.route});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => MultiBlocProvider(
        providers: [
          BlocProvider<ThemeCubit>(create: (context) => serverLocator<ThemeCubit>()),
          BlocProvider<LanguageCubit>(create: (context) => serverLocator<LanguageCubit>()),
          BlocProvider<AuthenticationCubit>(create: (context) => serverLocator<AuthenticationCubit>()),
          BlocProvider<CategoryCubit>(create: (context) => serverLocator<CategoryCubit>()),
          BlocProvider<ItemCubit>(create: (context) => serverLocator<ItemCubit>()),
          BlocProvider<ServiceOwnerStateCubit>(create: (context) => serverLocator<ServiceOwnerStateCubit>()),
          BlocProvider<TimerCubit>(create: (context) => serverLocator<TimerCubit>()),
          BlocProvider<TempUserCubit>(create: (context) => serverLocator<TempUserCubit>()),
          BlocProvider<NotificationCubit>(create: (context) => serverLocator<NotificationCubit>()),
        ],
        child: BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) => BlocBuilder<LanguageCubit, LanguageState>(
                builder: (context, state) => MaterialApp(
                      localizationsDelegates: AppLocalizations.localizationsDelegates,
                      supportedLocales: AppLocalizations.supportedLocales,
                      locale: serverLocator<LanguageModel>().locale,
                      darkTheme: AppThemeData.darkTheme,
                      theme: AppThemeData.lightTheme,
                      themeMode: serverLocator<AppThemeModel>().themeMode,
                      debugShowCheckedModeBanner: false,
                      home: SplashScreen(
                        route: widget.route,
                      ),
                      routes: {
                        AppRoutes.categoryScreen: (context) => CategoryScreen(),
                        AppRoutes.splash: (context) => SplashScreen(),
                        AppRoutes.mainAuthRoute: (context) => MainAuthScreen(),
                        AppRoutes.categoryDetails: (context) => CategoryDetailsScreen(),
                        AppRoutes.itemsScreen: (context) => ItemsScreen(),
                        AppRoutes.addTempUserScreen: (context) => AddTempUserScreen(),
                        AppRoutes.tempUserProfileScreen: (context) => TempUserProfileScreen(),
                      },
                    ))),
      ),
    );
  }
}

