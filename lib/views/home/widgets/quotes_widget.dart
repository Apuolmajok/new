import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sharecare/common/app_style.dart';
import 'package:sharecare/common/reusabletext.dart';
import 'package:sharecare/constants/constants.dart';

class QuotesWidgets extends StatelessWidget {
  const QuotesWidgets({super.key, required this.title, required this.image, required this.description, required this.time, this.onTap});

  final String title;
  final String image;
  final String description;
  final String time;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(right: 12.w),
        child: Container(
          width: width * 0.75,
          height: 192.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: kLightWhite,
          ),
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Padding(
                padding: EdgeInsets.all(8.w),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: SizedBox(
                    width: width * 0.8,
                    height: 112.h,
                    child: Image.network(image, fit: BoxFit.cover),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ReusableText(text: title, style: appStyle(12, kDark, FontWeight.w500)),
                        ReusableText(text: "❤️", style: appStyle(12, kPrimary, FontWeight.w500)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ReusableText(text: "Posted On:", style: appStyle(9, kGray, FontWeight.w500)),
                        ReusableText(text: time, style: appStyle(9, kDark, FontWeight.w500)),
                      ],
                    ),
                    ReusableText(text: description, style: appStyle(9, kDark, FontWeight.w500)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
