import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter/widgets.dart';
import 'package:sharecare/common/app_style.dart';
import 'package:sharecare/common/background_container.dart';
import 'package:sharecare/common/reusabletext.dart';
import 'package:sharecare/constants/constants.dart';
import 'package:sharecare/constants/uidata.dart';
import 'package:sharecare/views/home/widgets/urgentneeds_tiles.dart';

class AllUrgentNeeds extends StatelessWidget {
  const AllUrgentNeeds({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondary,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kSecondary,
        title: ReusableText(text: 'Urgent Needs', style: appStyle(13, kGray, FontWeight.w600),),
      ),
      body: BackgroundContainer(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(12.h),
            child: ListView(
                    children: List.generate(urgentneeds.length, (i) {
            var urgentneed = urgentneeds[i];
            return UrgentneedsTiles(urgentneed:urgentneed);
                    },
                  )
                ),
          ),
          )
      
    );
  }
}