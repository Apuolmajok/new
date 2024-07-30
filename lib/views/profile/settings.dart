import 'package:flutter/material.dart';
import 'package:sharecare/constants/constants.dart';
import 'package:sharecare/views/profile/drawer.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _privacySettingsEnabled = true;
  bool _notificationsEnabled = true;
  String _theme = 'Light';
  String _size = 'Medium';
  String _fontSize = 'Medium';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimary,
        
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AppPage()),
            ); // Navigate back to the previous screen
          },
        ),
      ),
      body: ListView(
        children: [
          // Notifications
          _buildSectionTitle(context, 'Notifications'),
          SwitchListTile(
            title: const Text('Enable Notifications'),
            subtitle: const Text('Toggle notifications on or off'),
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),

          // Security Settings
          _buildSectionTitle(context, 'Privacy and Security Settings'),
          ListTile(
            title: const Text('Manage Password'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to Change Password screen
            },
          ),
          SwitchListTile(
            title: const Text('Enable Privacy Settings'),
            subtitle: const Text('Toggle privacy settings on or off'),
            value: _privacySettingsEnabled,
            onChanged: (value) {
              setState(() {
                _privacySettingsEnabled = value;
              });
            },
          ),

          // Payment Settings
          _buildSectionTitle(context, 'Payment Settings'),
          ListTile(
            title: const Text('Manage Payment Methods'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to Manage Payment Methods screen
            },
          ),
          ListTile(
            title: const Text('Transaction History'),
            subtitle: const Text('View your payment and donation transactions'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to Transaction History screen
            },
          ),
          // Theme
          _buildSectionTitle(context, 'Appearance'),
          ListTile(
            title: const Text('Theme'),
            trailing: DropdownButton<String>(
              value: _theme,
              onChanged: (String? newValue) {
                setState(() {
                  _theme = newValue!;
                });
              },
              items: <String>['Light', 'Dark']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          ListTile(
            title: const Text('Size'),
            trailing: DropdownButton<String>(
              value: _size,
              onChanged: (String? newValue) {
                setState(() {
                  _size = newValue!;
                });
              },
              items: <String>['Small', 'Medium', 'Large']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          ListTile(
            title: const Text('Font Size'),
            trailing: DropdownButton<String>(
              value: _fontSize,
              onChanged: (String? newValue) {
                setState(() {
                  _fontSize = newValue!;
                });
              },
              items: <String>['Small', 'Medium', 'Large']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }
}
