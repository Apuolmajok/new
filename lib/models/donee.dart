import 'package:cloud_firestore/cloud_firestore.dart';

class Coords {
  final String id;
  final double latitude;
  final double longitude;
  final double latitudeDelta;
  final double longitudeDelta;
  final String address;
  final String title;

  Coords({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.latitudeDelta,
    required this.longitudeDelta,
    required this.address,
    required this.title,
  });

  factory Coords.fromMap(Map<String, dynamic> data) {
    return Coords(
      id: data['id'],
      latitude: data['latitude'],
      longitude: data['longitude'],
      latitudeDelta: data['latitudeDelta'] ?? 0.8122,
      longitudeDelta: data['longitudeDelta'] ?? 0.8122,
      address: data['address'],
      title: data['title'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'latitudeDelta': latitudeDelta,
      'longitudeDelta': longitudeDelta,
      'address': address,
      'title': title,
    };
  }
}

class Vendor {
  final String vendorId;
  final String title;
  final String time;
  final String imageUrl;
  final bool pickup;
  final bool delivery;
  final bool isAvailable;
  final String owner;
  final String code;
  final String logoUrl;
  final int rating;
  final String ratingCount;
  final String verification;
  final String verificationMessage;
  final Coords coords;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isApproved;

  Vendor({
    required this.vendorId,
    required this.title,
    required this.time,
    required this.imageUrl,
    required this.pickup,
    required this.delivery,
    required this.isAvailable,
    required this.owner,
    required this.code,
    required this.logoUrl,
    required this.rating,
    required this.ratingCount,
    required this.verification,
    required this.verificationMessage,
    required this.coords,
    required this.createdAt,
    required this.updatedAt,
    required this.isApproved,
  });

  factory Vendor.fromMap(Map<String, dynamic> data, String documentId) {
    return Vendor(
      vendorId: documentId,
      title: data['title'],
      time: data['time'],
      imageUrl: data['imageUrl'],
      pickup: data['pickup'],
      delivery: data['delivery'],
      isAvailable: data['isAvailable'],
      owner: data['owner'],
      code: data['code'],
      logoUrl: data['logoUrl'],
      rating: data['rating'],
      ratingCount: data['ratingCount'],
      verification: data['verification'],
      verificationMessage: data['verificationMessage'],
      coords: Coords.fromMap(data['coords']),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
       isApproved: data['isApproved'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'time': time,
      'imageUrl': imageUrl,
      'pickup': pickup,
      'delivery': delivery,
      'isAvailable': isAvailable,
      'owner': owner,
      'code': code,
      'logoUrl': logoUrl,
      'rating': rating,
      'ratingCount': ratingCount,
      'verification': verification,
      'verificationMessage': verificationMessage,
      'coords': coords.toMap(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isApproved': isApproved,
    };
  }
}
