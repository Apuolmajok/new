import 'package:flutter/material.dart';
import 'package:sharecare/services/auth_service.dart';
import 'package:sharecare/views/vendor/vendor_admin.dart'; // Vendor dashboard


class BusinessRegistrationCheckPage extends StatefulWidget {
  final String userId;

  const BusinessRegistrationCheckPage({Key? key, required this.userId}) : super(key: key);

  @override
  _BusinessRegistrationCheckPageState createState() => _BusinessRegistrationCheckPageState();
}

class _BusinessRegistrationCheckPageState extends State<BusinessRegistrationCheckPage> {
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _businessAddressController = TextEditingController();
  final AuthService _authService = AuthService();

  void _registerVendor() async {
    final businessName = _businessNameController.text;
    final businessAddress = _businessAddressController.text;

    if (businessName.isEmpty || businessAddress.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill out all fields'),
        ),
      );
      return;
    }

    try {
      String? vendorId = await _authService.registerVendor(widget.userId, businessName, businessAddress);
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

  void _goToDashboard() async {
    String? vendorId = await _authService.getVendorId(widget.userId);
    if (vendorId != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => VendorAdminDashboard(vendorId: vendorId)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vendor not found. Please register your business first.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Have you registered your business?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
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
            ElevatedButton(
              onPressed: _registerVendor,
              child: const Text('Register Business'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _goToDashboard,
              child: const Text('Go to Dashboard'),
            ),
          ],
        ),
      ),
    );
  }
}
