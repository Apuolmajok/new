import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sharecare/common/app_style.dart';
import 'package:sharecare/common/background_container.dart';
import 'package:sharecare/common/reusabletext.dart';
import 'package:sharecare/constants/constants.dart';
import 'package:sharecare/constants/uidata.dart';


import 'widget/category_tile.dart';



class AllCategories extends StatelessWidget {
  const AllCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation:0,
        backgroundColor: kOffWhite, 
        title: ReusableText(text: "Categories", 
        style: appStyle(12, kGray, FontWeight.w600),),
      ),

      body:BackgroundContainer(
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.only(left: 12.w, top: 10.h),
          height: height,
          child: ListView(
          scrollDirection: Axis.vertical,
          children: List.generate(categories.length, (i) {
            var category = categories[i];
            return CategoryTile(category: category);
          } ),
        ),
        ),
      ),
    );
  }
}
