import 'package:cloud_firestore/cloud_firestore.dart';


class Category {
  String categoryId;
  String name;
  String description;
  DateTime createdAt;
  DateTime updatedAt;

  Category({
    required this.categoryId,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromMap(Map<String, dynamic> data, String documentId) {
    return Category(
      categoryId: documentId,
      name: data['name'],
      description: data['description'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
