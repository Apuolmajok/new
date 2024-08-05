import 'package:flutter/material.dart';

class ConfirmationPage3 extends StatelessWidget {
  final String? bookCategory;
  final String? vehicleType;
  final int quantity;
  final bool isAnonymous;

  const ConfirmationPage3({
    super.key,
    required this.bookCategory,
    required this.vehicleType,
    required this.quantity,
    required this.isAnonymous,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54, // to simulate a modal overlay
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.circular(20),
          ),
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context),
              const SizedBox(height: 20),
              _buildConfirmationDetails(),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Go back to the form page
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.teal,
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.tealAccent),
                    ),
                    child: const Text('Back'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, true); // Confirm the donation
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.teal,
                    ),
                    child: const Text('Proceed to Pickup'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: [
        const Center(
          child: Column(
            children: [
              Icon(
                Icons.assignment_turned_in,
                color: Colors.white,
                size: 40,
              ),
              SizedBox(height: 8),
              Text(
                'Please Confirm',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmationDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow('Donation Category', 'Books'),
        _buildDetailRow('Book Category', bookCategory),
        _buildDetailRow('Book Quantity', '$quantity items Approx.'),
        _buildDetailRow('Charity Organization', 'Goodwill Charity'),
        _buildDetailRow('Vehicle Type', vehicleType),
        _buildDetailRow('You have chosen to donate anonymously', isAnonymous ? 'Yes' : 'No'),
      ],
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
          Text(
            value ?? '',
            style: const TextStyle(fontSize: 18, color: Colors.white),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
