import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VendorRegistrationForm extends StatefulWidget {
  final String? vendorId;
  final Map<String, dynamic>? vendorData;

  const VendorRegistrationForm({this.vendorId, this.vendorData, super.key});

  @override
  State<VendorRegistrationForm> createState() => _VendorRegistrationFormState();
}

class _VendorRegistrationFormState extends State<VendorRegistrationForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.vendorData != null) {
      _nameController.text = widget.vendorData!['businessName'];
      _addressController.text = widget.vendorData!['businessAddress'];
    }
  }

  void _saveVendor(BuildContext context) async {
    final name = _nameController.text;
    final address = _addressController.text;

    if (name.isEmpty || address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill out all fields'),
        ),
      );
      return;
    }

    try {
      if (widget.vendorId == null) {
        // Add new vendor
        await FirebaseFirestore.instance.collection('vendors').add({
          'businessName': name,
          'businessAddress': address,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vendor added successfully!'),
          ),
        );
      } else {
        // Update existing vendor
        await FirebaseFirestore.instance.collection('vendors').doc(widget.vendorId).update({
          'businessName': name,
          'businessAddress': address,
          'updatedAt': FieldValue.serverTimestamp(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vendor updated successfully!'),
          ),
        );
      }

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save vendor: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vendor Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Business Name'),
            ),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Business Address'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _saveVendor(context),
              child: Text(widget.vendorId == null ? 'Add Vendor' : 'Update Vendor'),
            ),
          ],
        ),
      ),
    );
  }
}
