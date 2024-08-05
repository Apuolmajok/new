import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sharecare/constants/constants.dart';
import 'package:sharecare/services/urgentneedservice.dart';
import 'package:sharecare/views/vendor/v_form.dart';


class ManageVendorsScreen extends StatelessWidget {
  final UrgentNeedsService _urgentNeedsService = UrgentNeedsService();

  void _deleteVendor(BuildContext context, String vendorId) async {
    try {
      await FirebaseFirestore.instance.collection('vendors').doc(vendorId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vendor deleted successfully!'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete vendor: $e'),
        ),
      );
    }
  }

  void _postToUrgentNeeds(BuildContext context, String vendorId) async {
    try {
      await _urgentNeedsService.addUrgentNeed({
        'vendorId': vendorId,
        'postedAt': FieldValue.serverTimestamp(),
        // Add other necessary fields
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vendor posted to urgent needs successfully!'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to post vendor to urgent needs: $e'),
        ),
      );
    }
  }

  void _removeFromUrgentNeeds(BuildContext context, String vendorId) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('urgentNeeds')
          .where('vendorId', isEqualTo: vendorId)
          .get();
      for (var doc in querySnapshot.docs) {
        await _urgentNeedsService.deleteUrgentNeed(doc.id);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vendor removed from urgent needs successfully!'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to remove vendor from urgent needs: $e'),
        ),
      );
    }
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
            final vendorData = vendor.data() as Map<String, dynamic>;
            return ListTile(
              title: Text(vendorData['businessName']),
              subtitle: Text(vendorData['businessAddress']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VendorRegistrationForm(
                            vendorId: vendor.id,
                            vendorData: vendorData,
                          ),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: kRed,),
                    onPressed: () => _deleteVendor(context, vendor.id),
                  ),
                  IconButton(
                    icon: const Icon(Icons.priority_high, color:kPrimary ,),
                    onPressed: () => _postToUrgentNeeds(context, vendor.id),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove_circle, color: kRed,),
                    onPressed: () => _removeFromUrgentNeeds(context, vendor.id),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
