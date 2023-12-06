import 'package:dalily/config/routes.dart';
import 'package:dalily/core/helper/image_helper.dart';
import 'package:dalily/core/screens/drawer.dart';
import 'package:dalily/core/util/styles.dart';
import 'package:dalily/features/categories/data/model/category_model.dart';
import 'package:dalily/features/categories/presentation/cubit/category_cubit.dart';
import 'package:dalily/features/language/presentation/cubit/language_cubit.dart';
import 'package:dalily/features/theme/presentation/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CategoryScreen extends StatelessWidget {

    CategoryScreen({Key? key}) : super(key: key);

   late List<CategoryModel> appCategories ;
   late bool isArabic ;
   late bool showBackIcon ;
  @override
  Widget build(BuildContext context) {
    isArabic = BlocProvider.of<LanguageCubit>(context).isArabic;
    if(ModalRoute.of(context)!.settings.arguments != null){
      appCategories = ModalRoute.of(context)!.settings.arguments as List<CategoryModel>;
      showBackIcon = true ;
    }else {
      appCategories =  BlocProvider.of<CategoryCubit>(context).appCategories;
      showBackIcon = false ;
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
          if(showBackIcon)
            IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_outlined,textDirection: isArabic ? TextDirection.ltr:TextDirection.rtl,),
          ),
        ],
      ),
      drawer: AppDrawer(isArabic:  isArabic,),
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
                Navigator.pushNamed(context, AppRoutes.itemsScreen,
                arguments: appCategories[index].id,
                );
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
                      child: FadeInImage(
                        placeholder: const AssetImage(ImageHelper.badConnection),
                        image: NetworkImage(appCategories[index].image,),
                        fit: BoxFit.fill,
                      ),
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
