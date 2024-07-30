import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageDonationsScreen extends StatelessWidget {
  const ManageDonationsScreen({Key? key}) : super(key: key);

  // Delete Donation
  Future<void> deleteDonation(String donationId) async {
    await FirebaseFirestore.instance.collection('donations').doc(donationId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('donations').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final donations = snapshot.data!.docs;

        return ListView.builder(
          itemCount: donations.length,
          itemBuilder: (context, index) {
            final donation = donations[index];
            return ListTile(
              title: Text(donation['donorName']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Email: ${donation['donorEmail']}'),
                  Text('Type: ${donation['donationType']}'),
                  Text('Amount: ${donation['amount']}'),
                  Text('Message: ${donation['message']}'),
                  Text('Created At: ${(donation['createdAt'] as Timestamp).toDate()}'),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  await deleteDonation(donation.id);
                },
              ),
              onTap: () {
                // Implement view or update details
              },
            );
          },
        );
      },
    );
  }
}
