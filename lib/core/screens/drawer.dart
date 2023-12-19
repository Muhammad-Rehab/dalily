import 'package:dalily/core/helper/admin_helper.dart';
import 'package:dalily/core/screens/admin_page.dart';
import 'package:dalily/core/util/styles.dart';
import 'package:dalily/features/authentication/presentation/widgets/logout_record.dart';
import 'package:dalily/features/language/presentation/widget/language_record.dart';
import 'package:dalily/features/theme/presentation/widgets/theme_record.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
          if (!AdminController.isAdmin)
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AdminPage(),
                  ),
                );
              },
              child: Text(
                'Admin page',
                style: titleSmall(context),
              ),
            ),
          const ThemeRecord(),
          const LanguageRecord(),
          Builder(builder: (context) {
            return LogInOrOutRecord();
          }),
          TextButton(
            onPressed: () async{
              await launchUrlString("https://wa.me/+201145135267",
              mode: LaunchMode.externalNonBrowserApplication,
              );
            },
            child: Text(
              AppLocalizations.of(context)!.contact_us,
              style: bodySmall(context).copyWith(fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
