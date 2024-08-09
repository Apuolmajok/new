import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';  // Import for date formatting
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

              // Convert the 'time' field from Timestamp to a formatted String
              String formattedTime = '';
              if (urgentNeed['time'] is Timestamp) {
                final timestamp = urgentNeed['time'] as Timestamp;
                formattedTime = DateFormat.yMMMd().add_jm().format(timestamp.toDate());
              } else {
                formattedTime = urgentNeed['time'] ?? 'No Time';
              }

              return UrgentneedsWidget(
                image: urgentNeed['imageUrl'] ?? 'https://via.placeholder.com/150',
                title: urgentNeed['title'] ?? 'No Title',
                time: formattedTime,
                rating: urgentNeed['rating'] ?? 0,
                logo: urgentNeed['logoUrl'] ?? 'https://via.placeholder.com/50',
              );
            }),
          ),
        );
      },
    );
  }
}
