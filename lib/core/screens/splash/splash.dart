import 'package:dalily/config/routes.dart';
import 'package:dalily/features/categories/presentation/cubit/category_cubit.dart';
import 'package:dalily/features/language/presentation/cubit/language_cubit.dart';
import 'package:dalily/features/theme/presentation/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  loadData()  {
    Future.wait([
    BlocProvider.of<LanguageCubit>(context).loadLanguage(),
    BlocProvider.of<ThemeCubit>(context).loadTheme(),
    BlocProvider.of<CategoryCubit>(context).getCategories(),
    ]).then((value) {
     Future.delayed(const Duration(seconds: 2),(){
       Navigator.pushReplacementNamed(context, AppRoutes.initialRoute);
     });
    });
  }
  @override
  void initState() {
    super.initState();
    loadData();
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Loading ..."),
      ),
    );
  }
}
