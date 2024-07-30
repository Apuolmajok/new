import 'package:cloud_firestore/cloud_firestore.dart';


class AppUser {
  String userId;
  String name;
  String email;
  String role;
  String verificationStatus;
  DateTime createdAt;
  DateTime updatedAt;

  AppUser({required this.userId, required this.name, required this.email, required this.role, required this.createdAt, required this.updatedAt, required this.verificationStatus});

  factory AppUser.fromMap(Map<String, dynamic> data, String documentId) {
    return AppUser(
      userId: documentId,
      name: data['name'],
      email: data['email'],      
      role: data['role'],
      verificationStatus: data['verificationStatus'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'verificationStatus':verificationStatus,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}


