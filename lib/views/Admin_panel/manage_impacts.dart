import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class ManageImpactsScreen extends StatelessWidget {
  const ManageImpactsScreen({Key? key}) : super(key: key);

  Future<void> addOrUpdateImpact({String? impactId, required Map<String, dynamic> impactData}) async {
    if (impactId == null) {
      await FirebaseFirestore.instance.collection('impacts').add(impactData);
    } else {
      await FirebaseFirestore.instance.collection('impacts').doc(impactId).update(impactData);
    }
  }

  Future<void> deleteImpact(String impactId) async {
    await FirebaseFirestore.instance.collection('impacts').doc(impactId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Impacts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ImpactFormScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('impacts').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final impacts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: impacts.length,
            itemBuilder: (context, index) {
              final impact = impacts[index];
              final impactData = impact.data() as Map<String, dynamic>;
              final impactTitle = impactData['title'] ?? 'No title';
              final impactDescription = impactData['description'] ?? 'No description';
              final impactImage = impactData['imageUrl'];
              final createdAt = (impactData['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();

              return ListTile(
                leading: impactImage != null ? Image.network(impactImage, width: 50, height: 50) : null,
                title: Text(impactTitle),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Description: $impactDescription'),
                    Text('Created At: $createdAt'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ImpactFormScreen(impactId: impact.id, impactData: impactData),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await deleteImpact(impact.id);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ImpactFormScreen extends StatefulWidget {
  final String? impactId;
  final Map<String, dynamic>? impactData;

  ImpactFormScreen({super.key, this.impactId, this.impactData});

  @override
  _ImpactFormScreenState createState() => _ImpactFormScreenState();
}

class _ImpactFormScreenState extends State<ImpactFormScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _imageUrl;
  XFile? _pickedImage;

  @override
  void initState() {
    super.initState();
    if (widget.impactData != null) {
      _titleController.text = widget.impactData!['title'] ?? '';
      _descriptionController.text = widget.impactData!['description'] ?? '';
      _imageUrl = widget.impactData!['imageUrl'];
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _pickedImage = pickedImage;
    });
  }

  Future<String?> _uploadImage(XFile image) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child('impact_images/${image.name}');
      await storageRef.putFile(File(image.path));
      return await storageRef.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error uploading image: $e'),
        ),
      );
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.impactId == null ? 'Add Impact' : 'Edit Impact'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 20),
            _pickedImage != null
                ? Image.file(File(_pickedImage!.path), height: 100)
                : _imageUrl != null
                    ? Image.network(_imageUrl!, height: 100)
                    : const SizedBox.shrink(),
            TextButton(
              onPressed: _pickImage,
              child: const Text('Pick Image'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String? imageUrl;
                if (_pickedImage != null) {
                  imageUrl = await _uploadImage(_pickedImage!);
                }

                final impactData = {
                  'title': _titleController.text,
                  'description': _descriptionController.text,
                  'imageUrl': imageUrl ?? _imageUrl,
                  'createdAt': FieldValue.serverTimestamp(),
                };
                await const ManageImpactsScreen().addOrUpdateImpact(impactId: widget.impactId, impactData: impactData);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
