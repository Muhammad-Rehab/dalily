import 'package:dalily/core/util/styles.dart';
import 'package:dalily/features/categories/presentation/widgets/category_drawer_button.dart';
import 'package:dalily/features/service_owners/prensentation/screens/admin_waiting_list.dart';
import 'package:flutter/material.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin',
          style: titleSmall(context).copyWith(color: Theme.of(context).colorScheme.surface),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AdminWaitingList()));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child: Text("Waiting List",
                style: titleSmall(context).copyWith(color: Theme.of(context).colorScheme.surface),
                ),
              ),
            ),
            const SizedBox(height: 20,),
            const CategoryDrawerButton(),
          ],
        ),
      ),
    );
  }
}
