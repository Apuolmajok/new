import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:sharecare/constants/constants.dart';
import 'package:sharecare/constants/uidata.dart';
import 'package:sharecare/views/home/widgets/volunteer_widget.dart';

class VolunteerLists extends StatelessWidget {
  const VolunteerLists({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 184.h,
      padding: EdgeInsets.only(left: 12.w, top: 10.h),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(volunteers.length, (i) {
          var volunteer = volunteers[i];
          return VolunteerWidget(
             title: volunteer['title'],
             image: volunteer['imageUrl'],
             time: volunteer['time'],
             description: volunteer['description'],
             );
        },
      )
    ));
  }
}