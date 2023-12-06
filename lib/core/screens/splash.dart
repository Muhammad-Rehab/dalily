import 'package:dalily/config/routes.dart';
import 'package:dalily/core/helper/admin_helper.dart';
import 'package:dalily/features/categories/presentation/cubit/category_cubit.dart';
import 'package:dalily/features/language/presentation/cubit/language_cubit.dart';
import 'package:dalily/features/notification/presentation/cubit/notification_cubit.dart';
import 'package:dalily/features/theme/presentation/cubit/theme_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {

  final String ? route ;
  const SplashScreen({Key? key, this.route}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  loadData()  {
    Future.wait([
      BlocProvider.of<LanguageCubit>(context).loadLanguage(),
      BlocProvider.of<ThemeCubit>(context).loadTheme(),
      BlocProvider.of<CategoryCubit>(context).getCategories(),
      BlocProvider.of<NotificationCubit>(context).initLocalNotification(context),
      AdminController.getAdminNumbers().then((value){
        if(FirebaseAuth.instance.currentUser != null){
          AdminController.isAdminAccount(FirebaseAuth.instance.currentUser!.phoneNumber!);
        }
      }),
    ]).then((value) {
      if(widget.route != null){
        Future.delayed(const Duration(seconds: 2),(){
          Navigator.pushReplacementNamed(context, widget.route!);
        });
      }else {
        Future.delayed(const Duration(seconds: 2),(){
          Navigator.pushReplacementNamed(context, AppRoutes.categoryScreen);
        });
      }
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