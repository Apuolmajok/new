import 'package:cloud_firestore/cloud_firestore.dart';


class Product {
  String productId;
  String name;
  String description;
  String vendorId;
  double price;
  DateTime createdAt;
  DateTime updatedAt;

  Product({
    required this.productId,
    required this.name,
    required this.description,
    required this.vendorId,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromMap(Map<String, dynamic> data, String documentId) {
    return Product(
      productId: documentId,
      name: data['name'],
      description: data['description'],
      vendorId: data['vendorId'],
      price: data['price'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'vendorId': vendorId,
      'price': price,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
