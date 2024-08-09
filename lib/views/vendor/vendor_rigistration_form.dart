import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sharecare/services/auth_service.dart';
import 'package:sharecare/views/vendor/vendor_admin.dart'; // Vendor dashboard

class VendorRegistrationScreen extends StatefulWidget {
  final String userId;

  const VendorRegistrationScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _VendorRegistrationScreenState createState() => _VendorRegistrationScreenState();
}

class _VendorRegistrationScreenState extends State<VendorRegistrationScreen> {
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _businessAddressController = TextEditingController();
  final AuthService _authService = AuthService();
  File? _selectedImage;
  String? _logoUrl;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _registerVendor() async {
    final businessName = _businessNameController.text;
    final businessAddress = _businessAddressController.text;

    if (businessName.isEmpty || businessAddress.isEmpty || _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill out all fields and select a logo'),
        ),
      );
      return;
    }

    try {
      // Upload the logo image and get the URL
      _logoUrl = await _authService.uploadVendorLogo(widget.userId, _selectedImage!);

      String? vendorId = await _authService.registerVendor(
        widget.userId,
        businessName,
        businessAddress,
        _logoUrl!, // Pass the logo URL
      );

      if (vendorId != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => VendorAdminDashboard(vendorId: vendorId)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to register vendor.'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Business'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _businessNameController,
              decoration: const InputDecoration(
                labelText: 'Business Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _businessAddressController,
              decoration: const InputDecoration(
                labelText: 'Business Address',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            _selectedImage != null
                ? Image.file(_selectedImage!, height: 150, width: 150)
                : const Text('No logo selected'),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Select Business Logo'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _registerVendor,
              child: const Text('Register Business'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VendorAdminDashboard(vendorId: widget.userId),
                  ),
                );
              },
              child: const Text('Go to Dashboard'),
            ),
          ],
        ),
      ),
    );
  }
}
