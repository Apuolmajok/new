import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sharecare/common/app_style.dart';
import 'package:sharecare/common/reusabletext.dart';
import 'package:sharecare/constants/constants.dart';

class ImpactDetailScreen extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final Timestamp createdAt;

  const ImpactDetailScreen({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(imageUrl),
              const SizedBox(height: 16),
              ReusableText(
                text: title,
                style: appStyle(20, kDark, FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ReusableText(
                text: "Posted on: $createdAt",
                style: appStyle(16, kGray, FontWeight.w500),
              ),
              const SizedBox(height: 16),
              ReusableText(
                text: description,
                style: appStyle(16, kDark, FontWeight.w400),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
