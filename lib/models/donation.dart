import 'package:cloud_firestore/cloud_firestore.dart';


class Donation {
  String donationId;
  String userId;
  String needId;
  String vendorId;
  String productId;
  double amount;
  DateTime timestamp;
  String impactId;

  Donation({
    required this.donationId,
    required this.userId,
    required this.needId,
    required this.vendorId,
    required this.productId,
    required this.amount,
    required this.timestamp,
    required this.impactId,
  });

  factory Donation.fromMap(Map<String, dynamic> data, String documentId) {
    return Donation(
      donationId: documentId,
      userId: data['userId'],
      needId:data['needId'],
      vendorId: data['vendorId'],
      productId: data['productId'],
      amount: data['amount'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      impactId: data['impactId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'needId': needId,
      'vendorId': vendorId,
      'productId': productId,
      'amount': amount,
      'timestamp': timestamp,
      'impactId': impactId,
    };
  }
}
