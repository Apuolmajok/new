import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sharecare/common/app_style.dart';
import 'package:sharecare/common/reusabletext.dart';
import 'package:sharecare/constants/constants.dart';
import 'package:sharecare/views/categories/category_page.dart';

// ignore: must_be_immutable
class CategoryTile extends StatelessWidget {
  CategoryTile({
    super.key,
    required this.category,
  });

  var category;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){
        Get.to(() => const CategoryPage(),
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 900)
        );
      },
      leading: CircleAvatar(
        radius: 20.r,
        backgroundColor: kGrayLight,
        child: Image.asset(category['imageUrl'], fit: BoxFit.contain,),
      ),
            
      title: ReusableText(text: category['title'], 
      style: appStyle(12, kGray, FontWeight.normal)),
            
      trailing: Icon(Icons.arrow_forward_ios_rounded, color: kGray, size: 15.r,),
    );
  }
}