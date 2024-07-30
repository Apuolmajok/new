import 'package:cloud_firestore/cloud_firestore.dart';


class Volunteer {
  String volunteerId;
  String userId;
  List<String> skills;
  String availability;
  DateTime createdAt;
  DateTime updatedAt;

  Volunteer({
    required this.volunteerId,
    required this.userId,
    required this.skills,
    required this.availability,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Volunteer.fromMap(Map<String, dynamic> data, String documentId) {
    return Volunteer(
      volunteerId: documentId,
      userId: data['userId'],
      skills: List<String>.from(data['skills']),
      availability: data['availability'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'skills': skills,
      'availability': availability,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
