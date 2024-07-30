import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sharecare/views/home/widgets/impact_widgets.dart';

class QuotesLists extends StatelessWidget {
  const QuotesLists({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('quotes').orderBy('createdAt', descending: true).limit(4).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final impacts = snapshot.data!.docs;

        return Container(
          height: 184.h,
          padding: EdgeInsets.only(left: 12.w, top: 10.h),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: List.generate(impacts.length, (i) {
              var impact = impacts[i].data() as Map<String, dynamic>;
              return ImpactWidgets(
                title: impact['title'],
                image: impact['imageUrl'],
                time: (impact['createdAt'] as Timestamp).toDate().toString(),
                description: impact['description'],
              );
            }),
          ),
        );
      },
    );
  }
}
