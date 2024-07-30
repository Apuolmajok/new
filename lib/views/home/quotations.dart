import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sharecare/common/app_style.dart';
import 'package:sharecare/common/background_container.dart';
import 'package:sharecare/common/reusabletext.dart';
import 'package:sharecare/constants/constants.dart';
import 'package:sharecare/views/home/widgets/impact_tiles.dart';
import 'package:sharecare/views/home/widgets/quotes_tiles.dart';

class AllQuotes extends StatelessWidget {
  const AllQuotes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondary,
      appBar: AppBar(
        elevation: 0.3,
        backgroundColor: kSecondary,
        title: ReusableText(text: 'Our Quotes', style: appStyle(13, kGray, FontWeight.w600)),
      ),
      body: BackgroundContainer(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(12.h),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('quotes').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final quotes = snapshot.data!.docs;

              return ListView.builder(
                itemCount: quotes.length,
                itemBuilder: (context, index) {
                  final quote = quotes[index].data() as Map<String, dynamic>;
                  return QuotesTiles(quote: quote);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
