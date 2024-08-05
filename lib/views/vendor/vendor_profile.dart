import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sharecare/constants/constants.dart';


class VendorProfileForm extends StatefulWidget {
  final String vendorId;

  const VendorProfileForm({required this.vendorId, super.key});

  @override
  _VendorProfileFormState createState() => _VendorProfileFormState();
}

class _VendorProfileFormState extends State<VendorProfileForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _coordsController = TextEditingController();
  File? _selectedLogo;
  String? _logoUrl;

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickLogo() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedLogo = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadLogo() async {
    if (_selectedLogo != null) {
      String filePath = 'vendorLogos/${widget.vendorId}.jpg';
      UploadTask uploadTask = _storage.ref().child(filePath).putFile(_selectedLogo!);
      TaskSnapshot snapshot = await uploadTask;
      _logoUrl = await snapshot.ref.getDownloadURL();
    }
  }

  Future<void> _updateProfile() async {
    if (_nameController.text.isNotEmpty && _addressController.text.isNotEmpty && _contactController.text.isNotEmpty && _coordsController.text.isNotEmpty) {
      await _uploadLogo();

      final profile = {
        'name': _nameController.text,
        'address': _addressController.text,
        'contact': _contactController.text,
        'coords': _coordsController.text,
        'logoUrl': _logoUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await _db.collection('vendors').doc(widget.vendorId).update(profile);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill out all fields'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: const Text('Complete Your Profile'),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
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
              TextField(
                controller: _contactController,
                decoration: const InputDecoration(labelText: 'Contact Information'),
              ),
              TextField(
                controller: _coordsController,
                decoration: const InputDecoration(labelText: 'Coordinates'),
              ),
              ElevatedButton(
                onPressed: _pickLogo,
                child: const Text('Pick Logo', style: TextStyle(color: kSecondary),),
              ),
              if (_selectedLogo != null)
                Image.file(
                  _selectedLogo!,
                  height: 100,
                ),
              ElevatedButton(
                onPressed: _updateProfile,
                child: const Text('Update Profile', style: TextStyle(color: kSecondary),),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
