import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sharecare/services/urgentneedservice.dart';
import 'package:sharecare/views/home/widgets/urgentneeds_widget.dart';

class UrgentNeedsList extends StatelessWidget {
  const UrgentNeedsList({super.key});

  @override
  Widget build(BuildContext context) {
    final urgentNeedsService = UrgentNeedsService();

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: urgentNeedsService.getRecentUrgentNeeds(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final urgentNeeds = snapshot.data!;

        return Container(
          height: 192.h,
          padding: EdgeInsets.only(left: 12.w, top: 10.h),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: List.generate(urgentNeeds.length, (i) {
              var urgentNeed = urgentNeeds[i];
              return UrgentneedsWidget(
                image: urgentNeed['imageUrl'],
                title: urgentNeed['title'],
                time: urgentNeed['time'],
                rating: urgentNeed['rating'],
                logo: urgentNeed['logoUrl'],
              );
            }),
          ),
        );
      },
    );
  }
}
