import 'package:dalily/config/routes.dart';
import 'package:dalily/config/super_injection_container.dart';
import 'package:dalily/config/theme.dart';
import 'package:dalily/core/helper/block_observer.dart';
import 'package:dalily/features/authentication/auth_injection.dart';
import 'package:dalily/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:dalily/features/authentication/presentation/cubit/authentications_state.dart';
import 'package:dalily/features/authentication/presentation/screans/main_auth.dart';
import 'package:dalily/features/categories/category_injection_container.dart';
import 'package:dalily/features/categories/presentation/cubit/category_cubit.dart';
import 'package:dalily/features/categories/presentation/cubit/category_states.dart';
import 'package:dalily/features/categories/presentation/screens/cat_screen_details.dart';
import 'package:dalily/features/categories/presentation/screens/category_screen.dart';
import 'package:dalily/core/screens/splash/splash.dart';
import 'package:dalily/features/categories/presentation/widgets/category_drawer_button.dart';
import 'package:dalily/features/language/data/model/language_model.dart';
import 'package:dalily/features/language/language_injection_container.dart';
import 'package:dalily/features/language/presentation/cubit/language_cubit.dart';
import 'package:dalily/features/language/presentation/cubit/language_state.dart';
import 'package:dalily/features/language/presentation/widget/language_record.dart';
import 'package:dalily/features/theme/data/model/app_theme_model.dart';
import 'package:dalily/features/theme/presentation/cubit/theme_cubit.dart';
import 'package:dalily/features/theme/presentation/cubit/theme_state.dart';
import 'package:dalily/features/theme/presentation/widgets/theme_record.dart';
import 'package:dalily/features/theme/theme_injection_container.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await superInjectionContainer();
  themeInjectionContainer();
  languageInjectionContainer();
  authInjectionContainer();
  categoryInjectionContainer();

  Bloc.observer = LoggingBlocObserver();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<ThemeCubit>(create: (context) => serverLocator<ThemeCubit>()),
      BlocProvider<LanguageCubit>(create: (context) => serverLocator<LanguageCubit>()),
      BlocProvider<AuthenticationCubit>(create: (context) => serverLocator<AuthenticationCubit>()),
      BlocProvider<CategoryCubit>(create: (context) => serverLocator<CategoryCubit>()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) => BlocBuilder<LanguageCubit, LanguageState>(
            builder: (context, state) => MaterialApp(
                  localizationsDelegates: AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                  locale: serverLocator<LanguageModel>().locale,
                  darkTheme: AppThemeData.darkTheme,
                  theme: AppThemeData.lightTheme,
                  themeMode: serverLocator<AppThemeModel>().themeMode,
                  debugShowCheckedModeBanner: false,
                  initialRoute: AppRoutes.splash,
                  routes: {
                    AppRoutes.initialRoute: (context) => HomePage(),
                    AppRoutes.splash: (context) => SplashScreen(),
                    AppRoutes.mainAuthRoute: (context) => MainAuthScreen(),
                    AppRoutes.categoryDetails: (context) => CategoryDetailsScreen(),
                    AppRoutes.categoryScreen: (context) => CategoryScreen(),
                  },
                )));
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ThemeRecord(),
            LanguageRecord(),
            CategoryDrawerButton(),
          ],
        ),
      ),
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Builder(builder: (context) {
              return ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<AuthenticationCubit>(context).initAuthCubit(InitialAuthenticationState());
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainAuthScreen()));
                  },
                  child: const Text("Log in screen"));
            }),
            ElevatedButton(
              onPressed: () {
                    Navigator.of(context).pushNamed(AppRoutes.categoryScreen,
                        arguments: BlocProvider.of<CategoryCubit>(context).appCategories);
              },
              child: const Text("Category Screen"),
            ),
          ],
        ),
      ),
    );
  }
}
