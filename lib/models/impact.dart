import 'package:cloud_firestore/cloud_firestore.dart';


class Impact {
  String impactId;
  String donationId;
  String description;
  DateTime createdAt;
  final String imageUrl;
  String title;

  Impact({
    required this.impactId,
    required this.donationId,
    required this.description,
    required this.createdAt,
    required this.imageUrl,
    required this.title,
  });

  factory Impact.fromMap(Map<String, dynamic> data, String documentId) {
    return Impact(
      impactId: documentId,
      donationId: data['donationId'],
      description: data['description'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      
      imageUrl: data['imageUrl'],
      title: data['title'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'donationId': donationId,
      'title': title,
      'description': description,
      "imageUrl": imageUrl,
      'createdAt': createdAt,
      
    };
  }
}
