import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageVendorsScreen extends StatelessWidget {
  const ManageVendorsScreen({Key? key}) : super(key: key);

  // Approve Vendor
  Future<void> approveVendor(String vendorId) async {
    await FirebaseFirestore.instance.collection('vendors').doc(vendorId).update({'isApproved': true});
  }

  // Reject Vendor
  Future<void> rejectVendor(String vendorId) async {
    await FirebaseFirestore.instance.collection('vendors').doc(vendorId).update({'isApproved': false});
  }

  // Delete Vendor
  Future<void> deleteVendor(String vendorId) async {
    await FirebaseFirestore.instance.collection('vendors').doc(vendorId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('vendors').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final vendors = snapshot.data!.docs;

        return ListView.builder(
          itemCount: vendors.length,
          itemBuilder: (context, index) {
            final vendor = vendors[index];
            final bool isApproved = vendor['isApproved'] ?? false;

            return ListTile(
              title: Text(vendor['title']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Owner: ${vendor['owner']}'),
                  Text('Email: ${vendor['email']}'),
                  Text('Phone: ${vendor['phone']}'),
                  Text('Status: ${isApproved ? 'Approved' : 'Pending'}'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.check, color: Colors.green),
                    onPressed: () async {
                      await approveVendor(vendor.id);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () async {
                      await rejectVendor(vendor.id);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await deleteVendor(vendor.id);
                    },
                  ),
                ],
              ),
              onTap: () {
                // Navigate to vendor details screen for updates (if needed)
              },
            );
          },
        );
      },
    );
  }
}
