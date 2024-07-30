class ClothesDonation {
  String? clothesType;
  String clothesDetails;
  int quantity;
  String? vehicleType;
  bool isAnonymous;
  String? message;
  DateTime donationDate;

  ClothesDonation({
    required this.clothesType,
    required this.clothesDetails,
    required this.quantity,
    required this.vehicleType,
    required this.isAnonymous,
    required this.message,
    required this.donationDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'clothesType': clothesType,
      'clothesDetails': clothesDetails,
      'quantity': quantity,
      'vehicleType': vehicleType,
      'isAnonymous': isAnonymous,
      'message': message,
      'donationDate': donationDate.toIso8601String(),
    };
  }

  factory ClothesDonation.fromMap(Map<String, dynamic> map) {
    return ClothesDonation(
      clothesType: map['clothesType'],
      clothesDetails: map['clothesDetails'],
      quantity: map['quantity'],
      vehicleType: map['vehicleType'],
      isAnonymous: map['isAnonymous'],
      message: map['message'],
      donationDate: DateTime.parse(map['donationDate']),
    );
  }
}
