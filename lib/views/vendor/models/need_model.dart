import 'package:cloud_firestore/cloud_firestore.dart';

class Need {
  final String needId;
  final String title;
  final String description;
  final String imageUrl; // Added imageUrl field
  final DateTime date; // Added date field
  final String vendorId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Need({
    required this.needId,
    required this.title,
    required this.description,
    required this.imageUrl, // Added imageUrl
    required this.date, // Added date
    required this.vendorId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Need.fromMap(Map<String, dynamic> data, String documentId) {
    return Need(
      needId: documentId,
      title: data['title'],
      description: data['description'],
      imageUrl: data['imageUrl'], // Map imageUrl
      date: (data['date'] as Timestamp).toDate(), // Map date
      vendorId: data['vendorId'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl, // Add imageUrl to map
      'date': date, // Add date to map
      'vendorId': vendorId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
