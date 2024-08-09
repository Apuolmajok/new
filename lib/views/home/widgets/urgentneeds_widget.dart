import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sharecare/common/app_style.dart';
import 'package:sharecare/common/reusabletext.dart';
import 'package:sharecare/constants/constants.dart';

class UrgentneedsWidget extends StatelessWidget {
  const UrgentneedsWidget({
    super.key,
    required this.image,
    required this.title,
    required this.rating,
    this.onTap,
    required this.logo,
    required this.time,
  });

  final String image;
  final String title;
  final String time;
  final String logo;
  final int rating;
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
                child: Stack(
                children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: SizedBox(
                        width: width * 0.8,
                        height: 112.h,
                        child: Image.network(
                          image, // URL to the image
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.error, color: kRed); // Error icon if image fails to load
                          },
                        ),
                      ),
                    ),
 

                   Positioned(
                      right: 10.w,
                      top: 10.h,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50.r),
                        child: Container(
                          color: kLightWhite,
                          child: Padding(
                            padding: EdgeInsets.all(2.h),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.r),
                              child: Image.network(
                                logo,  // The logo URL is used here
                                fit: BoxFit.cover,
                                width: 20.w,
                                height: 20.h,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.error, color: kRed);
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReusableText(
                      text: title,
                      style: appStyle(12, kDark, FontWeight.w500),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ReusableText(
                          text: "Donation time",
                          style: appStyle(9, kGray, FontWeight.w500),
                        ),
                        ReusableText(
                          text: time,
                          style: appStyle(9, kDark, FontWeight.w500),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        RatingBarIndicator(
                          rating: rating.toDouble(),
                          itemBuilder: (context, index) => const Icon(
                            Icons.star,
                            color: kPrimary,
                          ),
                          itemCount: 5,
                          itemSize: 15.h,
                        ),
                        SizedBox(width: 10.w),
                        ReusableText(
                          text: "+ $rating reviews and ratings",
                          style: appStyle(9, kGray, FontWeight.w500),
                        ),
                      ],
                    ),
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
