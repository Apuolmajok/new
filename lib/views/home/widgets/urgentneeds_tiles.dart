import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sharecare/common/app_style.dart';
import 'package:sharecare/common/reusabletext.dart';
import 'package:sharecare/constants/constants.dart';

class UrgentneedsTiles extends StatelessWidget {
  const UrgentneedsTiles({super.key, required this.urgentneed});

  final dynamic urgentneed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 8.h),
            height: 70.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: kOffWhite,
              borderRadius: BorderRadius.circular(9.r),
            ),
            child: Container(
              padding: EdgeInsets.all(4.r),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(12.r)),
                    child: Stack(
                      children: [
                        SizedBox(
                          height: 50.h,
                          width: 50.h,
                          child: Image.network(
                            urgentneed['imageUrl'] ?? 'https://via.placeholder.com/150',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.error, color: kRed);
                            },
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            padding: EdgeInsets.only(left: 6.w, bottom: 2.h),
                            color: kGray.withOpacity(0.6),
                            height: 16.h,
                            width: double.infinity,
                            child: RatingBarIndicator(
                              rating: (urgentneed['rating'] ?? 0).toDouble(),
                              itemCount: 5,
                              itemBuilder: (context, i) => const Icon(
                                Icons.star,
                                color: kPrimary,
                              ),
                              itemSize: 15.h,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ReusableText(
                        text: urgentneed['title'] ?? 'No title',
                        style: appStyle(11, kDark, FontWeight.w400),
                      ),
                      ReusableText(
                        text: "Donation time: ${urgentneed['time'] ?? 'No time'}",
                        style: appStyle(11, kGray, FontWeight.w400),
                      ),
                      SizedBox(
                        width: width * 0.7,
                        child: Text(
                          urgentneed['coords']?['address'] ?? 'No address',
                          overflow: TextOverflow.ellipsis,
                          style: appStyle(9, kGray, FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 6.h,
            right: 5.w,
            child: Container(
              height: 19.h,
              width: 60.w,
              decoration: BoxDecoration(
                color: urgentneed['isAvailable'] == true || urgentneed['isAvailable'] == null
                    ? kPrimary
                    : kSecondaryLight,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: ReusableText(
                  text: urgentneed['isAvailable'] == true || urgentneed['isAvailable'] == null
                      ? "Donate"
                      : "Closed",
                  style: appStyle(12, kLightWhite, FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
