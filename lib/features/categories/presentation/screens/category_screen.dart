import 'package:dalily/config/routes.dart';
import 'package:dalily/core/util/styles.dart';
import 'package:dalily/features/categories/data/model/category_model.dart';
import 'package:dalily/features/language/presentation/cubit/language_cubit.dart';
import 'package:dalily/features/theme/presentation/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CategoryScreen extends StatelessWidget {

    CategoryScreen({Key? key}) : super(key: key);

   late final List<CategoryModel> appCategories ;
   late bool isArabic ;
  @override
  Widget build(BuildContext context) {
    isArabic = BlocProvider.of<LanguageCubit>(context).isArabic;
    if(ModalRoute.of(context)!.settings.arguments != null){
      appCategories = ModalRoute.of(context)!.settings.arguments as List<CategoryModel>;
    }else {
      appCategories =[];
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.categories,
        style: titleMedium(context),
        ),
        foregroundColor: context.read<ThemeCubit>().isDark
            ? Theme.of(context).colorScheme.surface
            : Colors.black,
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_outlined,textDirection: isArabic ? TextDirection.ltr:TextDirection.rtl,),
          ),
        ],
      ),
      drawer: Drawer(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: isArabic ? const Radius.circular(0) : const Radius.circular(30) ,
            bottomRight: isArabic ? const Radius.circular(0) : const Radius.circular(30) ,
            topLeft: isArabic ? const Radius.circular(30) : const Radius.circular(0),
            bottomLeft: isArabic ? const Radius.circular(30) : const Radius.circular(0),
          )
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 145,
              mainAxisSpacing: 15,
              crossAxisSpacing: 20,
            ),
          itemCount: appCategories.length,
          itemBuilder: (context,index)=> InkWell(
            onTap: (){
              if(appCategories[index].subCategory.isNotEmpty){
                Navigator.pushNamed(context, AppRoutes.categoryScreen,
                arguments: appCategories[index].subCategory,
                );
              }else{
                // TODO navigate to items screen
                print('I am here 0');
              }
            },
            child: Container(
              padding: const EdgeInsets.only(left: 20,right: 20,top: 15),
             decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(10),
               color: Theme.of(context).colorScheme.secondary.withOpacity(.3),
             ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 80,
                    width: 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(appCategories[index].image,fit: BoxFit.fill,),
                    ),
                  ),
                  const SizedBox(height: 15,),
                  FittedBox(
                    child: Text(
                      isArabic
                          ? appCategories[index].arabicName
                          : appCategories[index].englishName,
                      style: titleSmall(context),
                    ),
                  ),
                ],
              ),

            ),
          ),
        ),
      ),
    );
  }
}
