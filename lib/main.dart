
import 'package:dalily/config/super_injection_container.dart';
import 'package:dalily/config/theme.dart';
import 'package:dalily/core/helper/block_observer.dart';
import 'package:dalily/features/authentication/auth_injection.dart';
import 'package:dalily/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:dalily/features/authentication/presentation/cubit/authentications_state.dart';
import 'package:dalily/features/authentication/presentation/screans/main_auth.dart';
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

  Bloc.observer = LoggingBlocObserver();
  runApp(MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (context)=> serverLocator<ThemeCubit>()),
        BlocProvider<LanguageCubit>(create: (context)=> serverLocator<LanguageCubit>()),
        BlocProvider<AuthenticationCubit>(create: (context)=> serverLocator<AuthenticationCubit>()),
      ],
      child:const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  loadData()async{
      BlocProvider.of<LanguageCubit>(context).loadLanguage();
      BlocProvider.of<ThemeCubit>(context).loadTheme();
  }



  @override
  void initState() {
    loadData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return BlocBuilder<ThemeCubit,ThemeState>(builder: (context,state) =>
        BlocBuilder<LanguageCubit,LanguageState>(builder: (context,state) =>  MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: serverLocator<LanguageModel>().locale,
          darkTheme: AppThemeData.darkTheme,
          theme: AppThemeData.lightTheme,
          themeMode: serverLocator<AppThemeModel>().themeMode,
          debugShowCheckedModeBanner: false,
          home: const HomePage(),
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
          children: [
            ThemeRecord(),
            LanguageRecord(),
          ],
        ),
      ),
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Builder(
                builder: (context) {
                  return ElevatedButton(onPressed: (){
                    BlocProvider.of<AuthenticationCubit>(context).initAuthCubit(InitialAuthenticationState());
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> MainAuthScreen()));
                  }, child: const Text("Log in screen"));
                }
            )
          ],
        ),
      ),
    );
  }
}


