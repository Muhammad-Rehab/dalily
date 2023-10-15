
import 'package:dalily/config/super_injection_container.dart';
import 'package:dalily/config/theme.dart';
import 'package:dalily/features/app_theme/data/model/app_theme_model.dart';
import 'package:dalily/features/app_theme/presentation/cubit/theme_cubit.dart';
import 'package:dalily/features/app_theme/presentation/cubit/theme_state.dart';
import 'package:dalily/features/app_theme/presentation/widgets/theme_record.dart';
import 'package:dalily/features/app_theme/theme_injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await superInjectionContainer();
  themeInjectionContainer();

  runApp(MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (context)=> serverLocator<ThemeCubit>()),
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
  loadData(){
    BlocProvider.of<ThemeCubit>(context).loadTheme();
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit,ThemeState>(builder: (context,state)=>MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale:const Locale('ar'),
      darkTheme: AppThemeData.darkTheme,
      theme: AppThemeData.lightTheme,
      themeMode: serverLocator<AppThemeModel>().themeMode,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        drawer: Drawer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ThemeRecord(),
            ],
          ),
        ),
        appBar: AppBar(
        ),
      ),
    ));
  }
}

