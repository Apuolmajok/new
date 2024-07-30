

class FundsDonation {
  String donorName;
  double amount;
  String email;
  String phoneNumber;
  String message;
  String currency;
  DateTime donationDate;

  FundsDonation({
    required this.donorName,
    required this.amount,
    required this.email,
    required this.phoneNumber,
    this.message = '',
    required this.currency,
    required this.donationDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'donorName': donorName,
      'amount': amount,
      'email': email,
      'phoneNumber': phoneNumber,
      'message': message,
      'currency': currency,
      'donationDate': donationDate.toIso8601String(),
    };
  }

  factory FundsDonation.fromMap(Map<String, dynamic> map) {
    return FundsDonation(
      donorName: map['donorName'],
      amount: map['amount'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      message: map['message'] ?? '',
      currency: map['currency'],
      donationDate: DateTime.parse(map['donationDate']),
    );
  }
}
