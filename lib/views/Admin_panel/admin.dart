import 'package:flutter/material.dart';
import 'package:sharecare/constants/constants.dart';
import 'package:sharecare/views/Admin_panel/manage_categories.dart';
import 'package:sharecare/views/Admin_panel/manage_donations.dart';
import 'package:sharecare/views/Admin_panel/manage_impacts.dart';
import 'package:sharecare/views/Admin_panel/manage_products.dart';
import 'package:sharecare/views/Admin_panel/manage_users.dart';
import 'package:sharecare/views/Admin_panel/manage_vendors.dart';
import 'package:sharecare/views/Admin_panel/manage_volunteers.dart';
import 'package:sharecare/views/Admin_panel/manage_quotes.dart';
import 'package:sharecare/views/entrypoint.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel', style: TextStyle(color: kPrimary)),
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: kSecondary),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MainScreen()),
              );
            },
          ),
        ],
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            ExpansionTile(
              title: Text('Manage Users'),
              children: [
                SizedBox(
                  height: 500, // Adjust the height as needed
                  child: ManageUsersScreen(),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('Manage Vendors'),
              children: [
                SizedBox(
                  height: 500, // Adjust the height as needed
                  child: ManageVendorsScreen(),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('Manage Donations'),
              children: [
                SizedBox(
                  height: 500, // Adjust the height as needed
                  child: ManageDonationsScreen(),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('Manage Products'),
              children: [
                SizedBox(
                  height: 500, // Adjust the height as needed
                  child: ManageProductsScreen(),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('Manage Volunteers'),
              children: [
                SizedBox(
                  height: 500, // Adjust the height as needed
                  child: ManageVolunteersScreen(),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('Manage Categories'),
              children: [
                SizedBox(
                  height: 500, // Adjust the height as needed
                  child: ManageCategoriesScreen(),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('Manage Impacts'),
              children: [
                SizedBox(
                  height: 500, // Adjust the height as needed
                  child: ManageImpactsScreen(),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('Manage Quotes'),
              children: [
                SizedBox(
                  height: 500, // Adjust the height as needed
                  child: ManageQuotesScreen(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
