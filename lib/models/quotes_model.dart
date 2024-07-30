import 'package:cloud_firestore/cloud_firestore.dart';


class Quotes {
  String quotesId;
 
  String description;
  DateTime createdAt;
  final String imageUrl;
  String title;

  Quotes ({
    required this.quotesId,
   
    required this.description,
    required this.createdAt,
    required this.imageUrl,
    required this.title,
  });

  factory Quotes .fromMap(Map<String, dynamic> data, String documentId) {
    return Quotes (
      quotesId: documentId,
     
      description: data['description'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      
      imageUrl: data['imageUrl'],
      title: data['title'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      
      'title': title,
      'description': description,
      "imageUrl": imageUrl,
      'createdAt': createdAt,
      
    };
  }
}
