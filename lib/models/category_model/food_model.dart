class FoodDonation {
  String? source;
  String? foodType;
  String foodItems;
  DateTime cookedDate;
  DateTime expiryDate;
  int quantity;
  String? vehicleType;
  bool isAnonymous;
  String? wishMessage;
  DateTime donationDate;

  FoodDonation({
    required this.source,
    required this.foodType,
    required this.foodItems,
    required this.cookedDate,
    required this.expiryDate,
    required this.quantity,
    required this.vehicleType,
    required this.isAnonymous,
    required this.wishMessage,
    required this.donationDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'source': source,
      'foodType': foodType,
      'foodItems': foodItems,
      'cookedDate': cookedDate.toIso8601String(),
      'expiryDate': expiryDate.toIso8601String(),
      'quantity': quantity,
      'vehicleType': vehicleType,
      'isAnonymous': isAnonymous,
      'wishMessage': wishMessage,
      'donationDate': donationDate.toIso8601String(),
    };
  }

  factory FoodDonation.fromMap(Map<String, dynamic> map) {
    return FoodDonation(
      source: map['source'],
      foodType: map['foodType'],
      foodItems: map['foodItems'],
      cookedDate: DateTime.parse(map['cookedDate']),
      expiryDate: DateTime.parse(map['expiryDate']),
      quantity: map['quantity'],
      vehicleType: map['vehicleType'],
      isAnonymous: map['isAnonymous'],
      wishMessage: map['wishMessage'],
      donationDate: DateTime.parse(map['donationDate']),
    );
  }
}
