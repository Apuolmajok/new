import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sharecare/common/app_style.dart';
import 'package:sharecare/common/reusabletext.dart';
import 'package:sharecare/constants/constants.dart';
import 'package:sharecare/constants/uidata.dart';
import 'package:sharecare/controllers/category_controller.dart';
import 'package:sharecare/views/categories/FOOD%20copy/food_donation.dart';
import 'package:sharecare/views/categories/all_categories.dart';
import 'package:sharecare/views/categories/baby_donation.dart';
import 'package:sharecare/views/categories/books_donation.dart';
import 'package:sharecare/views/categories/clothes_donation.dart';
import 'package:sharecare/views/categories/funds.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategoryController());
    return Container(
      height: 75.h,
      padding: EdgeInsets.only(left: 12.w, top: 10.h),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(categories.length, (i) {
          var category = categories[i];
          return GestureDetector(
            onTap: () {
              if (controller.categoryValue == category['_id']) {
                controller.updateCategory = '';
                controller.updateTitle = '';
              } else if (category['value'] == 'more') {
                Get.to(
                  () => const AllCategories(),
                  transition: Transition.fadeIn,
                  duration: const Duration(milliseconds: 900),
                );
              } else {
                controller.updateCategory = category['_id'];
                controller.updateTitle = category['title'];

                // Navigate to the specific category page
                switch (category['title']) {
                  case 'Food':
                    Get.to(
                      () => const FoodDonationForm(),
                      transition: Transition.fadeIn,
                      duration: const Duration(milliseconds: 900),
                    );
                    break;
                  case 'Funds':
                    Get.to(
                      () => FundsPage(),
                      transition: Transition.fadeIn,
                      duration: const Duration(milliseconds: 900),
                    );
                    break;
                  case 'Clothes':
                    Get.to(
                      () => const ClothesDonationForm(),
                      transition: Transition.fadeIn,
                      duration: const Duration(milliseconds: 900),
                    );
                     break;
                    case 'Education':
                    Get.to(
                      () => const BooksDonationForm(),
                      transition: Transition.fadeIn,
                      duration: const Duration(milliseconds: 900),
                    );
                    break;

                    case 'Babycare':
                    Get.to(
                      () => const BabyDonationForm(),
                      transition: Transition.fadeIn,
                      duration: const Duration(milliseconds: 900),
                    );
                    break;
                  // Add more cases for other categories
                  default:
                    // Handle other categories if needed
                    break;
                }
              }
            },
            child: Obx(
              () => Container(
                margin: EdgeInsets.only(right: 5.w),
                padding: EdgeInsets.only(top: 10.h),
                width: width * 0.17,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.r),
                  border: Border.all(
                    color: controller.categoryValue == category['_id'] ? kPrimary : kOffWhite,
                    width: .5.w,
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 35.h,
                      child: Image.asset(
                        category['imageUrl'],
                        fit: BoxFit.cover,
                      ),
                    ),
                    ReusableText(
                      text: category["title"],
                      style: appStyle(12, kSecondary, FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
