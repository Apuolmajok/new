import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sharecare/constants/constants.dart';
import 'package:sharecare/services/imageservice.dart';
import 'package:sharecare/views/entrypoint.dart';
import 'package:sharecare/views/vendor/vendor_profile.dart';
import 'dart:io';
import 'package:sharecare/views/vendor/vendorservice.dart';

class VendorAdminDashboard extends StatefulWidget {
  final String vendorId;

  const VendorAdminDashboard({required this.vendorId, super.key});

  @override
  _VendorAdminDashboardState createState() => _VendorAdminDashboardState();
}

class _VendorAdminDashboardState extends State<VendorAdminDashboard> {
  final VendorService _vendorService = VendorService();
  final ImageService _imageService = ImageService();

  final TextEditingController _postTitleController = TextEditingController();
  final TextEditingController _postDescriptionController = TextEditingController();

  File? _selectedImage;
  String? _imageUrl;

  void _pickImage() async {
    File? image = await _imageService.pickImage();
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  Future<void> _addOrUpdatePost([String? postId]) async {
    if (_postTitleController.text.isNotEmpty && _postDescriptionController.text.isNotEmpty) {
      if (_selectedImage != null) {
        _imageUrl = await _imageService.uploadImage(_selectedImage!, widget.vendorId);
      }

      final post = {
        'vendorId': widget.vendorId,
        'title': _postTitleController.text,
        'description': _postDescriptionController.text,
        'imageUrl': _imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
      };

      if (postId == null) {
        await _vendorService.addPost(post);
      } else {
        await _vendorService.updatePost(postId, post);
      }

      _postTitleController.clear();
      _postDescriptionController.clear();
      setState(() {
        _selectedImage = null;
        _imageUrl = null;
      });
      Navigator.of(context).pop();
    }
  }

  void _showPostDialog([String? postId, Map<String, dynamic>? postData]) {
    if (postData != null) {
      _postTitleController.text = postData['title'];
      _postDescriptionController.text = postData['description'];
      _imageUrl = postData['imageUrl'];
    } else {
      _postTitleController.clear();
      _postDescriptionController.clear();
      _selectedImage = null;
      _imageUrl = null;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(postId == null ? 'Add Post' : 'Update Post'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _postTitleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: _postDescriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Pick Image', style: TextStyle(color: kSecondary)),
              ),
              if (_selectedImage != null)
                Image.file(
                  _selectedImage!,
                  height: 100,
                ),
              if (_imageUrl != null && _selectedImage == null)
                Image.network(
                  _imageUrl!,
                  height: 100,
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => _addOrUpdatePost(postId),
              child: const Text('Save', style: TextStyle(color: kSecondary)),
            ),
          ],
        );
      },
    );
  }

  void _deletePost(String postId) async {
    await _vendorService.deletePost(postId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vendor Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showPostDialog(),
          ),
         
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
      body: Column(
        children: [
          VendorProfileForm(vendorId: widget.vendorId),
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _vendorService.getVendorPosts(widget.vendorId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final posts = snapshot.data!;

                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return ListTile(
                      title: Text(post['title']),
                      subtitle: Text(post['description']),
                      leading: post['imageUrl'] != null
                          ? Image.network(post['imageUrl'])
                          : null,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _showPostDialog(post['id'], post),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deletePost(post['id']),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
