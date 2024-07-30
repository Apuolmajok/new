import 'package:flutter/material.dart';

class VendorAdminDashboard extends StatelessWidget {
  final String vendorId;

  const VendorAdminDashboard({required this.vendorId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vendor Admin Dashboard'),
      ),
      body: Center(
        child: Text('Welcome to the admin dashboard for vendor: $vendorId'),
      ),
    );
  }
}
