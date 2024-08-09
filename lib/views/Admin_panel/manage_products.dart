import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sharecare/constants/constants.dart';
import 'package:sharecare/services/urgentneedservice.dart';
import 'package:sharecare/views/vendor/v_form.dart';

class ManageProductsScreen extends StatelessWidget {
  final UrgentNeedsService _urgentNeedsService = UrgentNeedsService();

  void _deleteProduct(BuildContext context, String productId) async {
    try {
      await FirebaseFirestore.instance.collection('products').doc(productId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product deleted successfully!'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete product: $e'),
        ),
      );
    }
  }

  void _postToUrgentNeeds(BuildContext context, Map<String, dynamic> productData) async {
    try {
      await _urgentNeedsService.addUrgentNeed({
        'vendorId': productData['vendorId'],
        'imageUrl': productData['imageUrl'] ?? '',
        'title': productData['title'] ?? '',
        'time': FieldValue.serverTimestamp(),
        'rating': productData['rating'] ?? 0,
        'coords': productData['coords'] ?? {},
        'isAvailable': true,
        'postedAt': FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product posted to urgent needs successfully!'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to post product to urgent needs: $e'),
        ),
      );
    }
  }

  void _removeFromUrgentNeeds(BuildContext context, String productId) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('urgentNeeds')
          .where('vendorId', isEqualTo: productId)
          .get();
      for (var doc in querySnapshot.docs) {
        await _urgentNeedsService.deleteUrgentNeed(doc.id);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product removed from urgent needs successfully!'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to remove product from urgent needs: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('products').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final products = snapshot.data!.docs;

        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            final productData = product.data() as Map<String, dynamic>;

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('vendors').doc(productData['vendorId']).get(),
              builder: (context, vendorSnapshot) {
                if (vendorSnapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (!vendorSnapshot.hasData || !vendorSnapshot.data!.exists) {
                  return ListTile(
                    title: Text(productData['title'] ?? 'No Title'),
                    subtitle: const Text('Vendor information not available'),
                    trailing: const Icon(Icons.error, color: kRed),
                  );
                }

                final vendorData = vendorSnapshot.data!.data() as Map<String, dynamic>?;

                // Safeguard against missing fields by providing defaults
                final String logoUrl = vendorData?['logoUrl'] ?? '';
                final String businessName = vendorData?['businessName'] ?? 'Unknown Vendor';

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: logoUrl.isNotEmpty ? NetworkImage(logoUrl) : null,
                    child: logoUrl.isEmpty ? const Icon(Icons.business) : null,
                  ),
                  title: Text(productData['title'] ?? 'No Title'),
                  subtitle: Text('Vendor: $businessName'),
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
                                vendorId: productData['vendorId'] ?? '',
                                vendorData: vendorData,
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: kRed,),
                        onPressed: () => _deleteProduct(context, product.id),
                      ),
                      IconButton(
                        icon: const Icon(Icons.priority_high, color: kPrimary),
                        onPressed: () => _postToUrgentNeeds(context, productData),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove_circle, color: kRed,),
                        onPressed: () => _removeFromUrgentNeeds(context, product.id),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
