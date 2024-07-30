import 'package:flutter/material.dart';
import 'package:sharecare/constants/constants.dart';
//import 'package:sharecare/common/custom_container.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:sharecare/constants/constants.dart';
import 'package:sharecare/views/profile/drawer.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF30b9b2),
                borderRadius:
                    BorderRadius.circular(10.0), // Radius of the corners
              ),
              // Set your desired background color here
              child: Column(
                children: [
                  // Profile Picture and User Details
                  Center(
                    child: Column(
                      children: [
                        // Profile Picture
                        CircleAvatar(
                          radius: 80,
                          backgroundImage: const NetworkImage(
                              'https://example.com/profile_picture.jpg'), // Replace with actual image URL or asset
                          backgroundColor: Colors.grey[200],
                        ),
                        const SizedBox(height: 15.0),
                        // User Name
                        const Text(
                          'Mercy James',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        // User Email
                        Text(
                          'mercyjames@gmail.com',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  // Profile Options
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person_2),
              title: const Text('Personal Details'),
              onTap: () {
                // Handle Donations action
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PersonalDetailsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.circle),
              title: const Text('My Donations'),
              onTap: () {
                // Handle Donations action
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Change Password'),
              onTap: () {
                // Navigate to Settings page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PasswordManagementPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_city_sharp),
              title: const Text('Manage Address'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ManageAddressPage()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                // Handle Logout action
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PasswordManagementPage extends StatefulWidget {
  @override
  _PasswordManagementPageState createState() => _PasswordManagementPageState();
}

class _PasswordManagementPageState extends State<PasswordManagementPage> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  // Function to handle password change
  Future<void> _changePassword() async {
    setState(() {
      _errorMessage = '';
    });

    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (newPassword != confirmPassword) {
      setState(() {
        _errorMessage = 'New passwords do not match.';
      });
      return;
    }

    // Simple validation for new password length
    if (newPassword.length < 8) {
      setState(() {
        _errorMessage = 'New password must be at least 8 characters long.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call for changing password
    await Future.delayed(const Duration(seconds: 2));

    // Handle response (In a real app, you would process the response from the server)
    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password changed successfully!')),
    );

    // Clear text fields after successful password change
    _currentPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Change Password Section
            const Text(
              'Change Password',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _currentPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Current Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm New Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _isLoading ? null : _changePassword,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Change Password'),
            ),
            if (_errorMessage.isNotEmpty) ...[
              const SizedBox(height: 16.0),
              Text(
                _errorMessage,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ManageAddressPage extends StatefulWidget {
  @override
  _ManageAddressPageState createState() => _ManageAddressPageState();
}

class _ManageAddressPageState extends State<ManageAddressPage> {
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();
  bool _isEditing = false;
  bool _isLoading = false;
  String _errorMessage = '';

  @override

  // Function to handle saving the address
  // ignore: override_on_non_overriding_member
  Future<void> _saveAddress() async {
    setState(() {
      _errorMessage = '';
    });

    // Retrieve the address details from the controllers
    final street = _streetController.text;
    final city = _cityController.text;
    final state = _stateController.text;
    final zip = _zipController.text;

    // Basic validation
    if (street.isEmpty || city.isEmpty || state.isEmpty || zip.isEmpty) {
      setState(() {
        _errorMessage = 'All fields are required.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call for saving address
    await Future.delayed(const Duration(seconds: 2));

    // Handle response (In a real app, you would process the response from the server)
    setState(() {
      _isLoading = false;
      _isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Address updated successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isEditing) ...[
              const Text(
                'Edit Address',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _streetController,
                decoration: const InputDecoration(
                  labelText: 'Street',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12.0),
              TextField(
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: 'City',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12.0),
              TextField(
                controller: _stateController,
                decoration: const InputDecoration(
                  labelText: 'State',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12.0),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveAddress,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Save Address'),
              ),
              if (_errorMessage.isNotEmpty) ...[
                const SizedBox(height: 16.0),
                Text(
                  _errorMessage,
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
              ],
            ] else ...[
              const Text(
                'Address Details',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              const Text('Street: 123 Main Street'),
              const Text('City: Springfield'),
              const Text('State: IL'),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isEditing = true;
                  });
                },
                child: const Text('Edit Address'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class PersonalDetailsPage extends StatefulWidget {
  @override
  _PersonalDetailsPageState createState() => _PersonalDetailsPageState();
}

class _PersonalDetailsPageState extends State<PersonalDetailsPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  bool _isEditing = false;
  bool _isLoading = false;
  String _errorMessage = '';

  // Function to handle saving the address
  Future<void> _saveAddress() async {
    setState(() {
      _errorMessage = '';
    });

    // Retrieve the address details from the controllers
    final street = _nameController.text;
    final city = _emailController.text;
    final state = _addressController.text;

    // Basic validation
    if (street.isEmpty || city.isEmpty || state.isEmpty) {
      setState(() {
        _errorMessage = 'All fields are required.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call for saving address
    await Future.delayed(const Duration(seconds: 2));

    // Handle response (In a real app, you would process the response from the server)
    setState(() {
      _isLoading = false;
      _isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Address updated successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isEditing) ...[
              const Text(
                'Edit Personal Details',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12.0),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12.0),
              TextField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12.0),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveAddress,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Save Details'),
              ),
              if (_errorMessage.isNotEmpty) ...[
                const SizedBox(height: 16.0),
                Text(
                  _errorMessage,
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
              ],
            ] else ...[
              const Text(
                'Personal Details',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              const Text('Name: MERCY'),
              const Text('Email: BLAHDHYDd'),
              const Text('Address: IL'),
              const SizedBox(height: 16.0),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isEditing = true;
                  });
                },
                child: const Text('Edit Details'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
