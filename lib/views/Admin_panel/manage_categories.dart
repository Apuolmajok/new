import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageCategoriesScreen extends StatelessWidget {
  const ManageCategoriesScreen({Key? key}) : super(key: key);

  // Add or Update Category
  Future<void> addOrUpdateCategory({String? categoryId, required Map<String, dynamic> categoryData}) async {
    if (categoryId == null) {
      await FirebaseFirestore.instance.collection('categories').add(categoryData);
    } else {
      await FirebaseFirestore.instance.collection('categories').doc(categoryId).update(categoryData);
    }
  }

  // Delete Category
  Future<void> deleteCategory(String categoryId) async {
    await FirebaseFirestore.instance.collection('categories').doc(categoryId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Categories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CategoryFormScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('categories').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final categories = snapshot.data!.docs;

          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return ListTile(
                title: Text(category['name']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Description: ${category['description']}'),
                    Text('Created At: ${(category['createdAt'] as Timestamp).toDate()}'),
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
                            builder: (context) => CategoryFormScreen(categoryId: category.id, categoryData: category.data() as Map<String, dynamic>),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await deleteCategory(category.id);
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

class CategoryFormScreen extends StatelessWidget {
  final String? categoryId;
  final Map<String, dynamic>? categoryData;

  CategoryFormScreen({this.categoryId, this.categoryData});

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (categoryData != null) {
      _nameController.text = categoryData!['name'];
      _descriptionController.text = categoryData!['description'];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryId == null ? 'Add Category' : 'Edit Category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Category Name'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final categoryData = {
                  'name': _nameController.text,
                  'description': _descriptionController.text,
                  'createdAt': FieldValue.serverTimestamp(),
                };
                await ManageCategoriesScreen().addOrUpdateCategory(categoryId: categoryId, categoryData: categoryData);
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
