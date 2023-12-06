import 'package:dalily/features/authentication/presentation/widgets/logout_record.dart';
import 'package:dalily/features/categories/presentation/widgets/category_drawer_button.dart';
import 'package:dalily/features/language/presentation/widget/language_record.dart';
import 'package:dalily/features/theme/presentation/widgets/theme_record.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final bool isArabic;

  const AppDrawer({Key? key, required this.isArabic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topRight: isArabic ? const Radius.circular(0) : const Radius.circular(30),
        bottomRight: isArabic ? const Radius.circular(0) : const Radius.circular(30),
        topLeft: isArabic ? const Radius.circular(30) : const Radius.circular(0),
        bottomLeft: isArabic ? const Radius.circular(30) : const Radius.circular(0),
      )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Builder(builder: (context) {
            return const CategoryDrawerButton();
          }),
          const ThemeRecord(),
          const LanguageRecord(),
          Builder(builder: (context) {
            return LogInOrOutRecord();
          }),
        ],
      ),
    );
  }
}
