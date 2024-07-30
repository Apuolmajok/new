import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class ManageQuotesScreen extends StatelessWidget {
  const ManageQuotesScreen({super.key});

  Future<void> addOrUpdateQuote({String? quoteId, required Map<String, dynamic> quoteData}) async {
    if (quoteId == null) {
      await FirebaseFirestore.instance.collection('quotes').add(quoteData);
    } else {
      await FirebaseFirestore.instance.collection('quotes').doc(quoteId).update(quoteData);
    }
  }

  Future<void> deleteQuote(String quoteId) async {
    await FirebaseFirestore.instance.collection('quotes').doc(quoteId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Quotes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QuoteFormScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('quotes').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final quotes = snapshot.data!.docs;

          return ListView.builder(
            itemCount: quotes.length,
            itemBuilder: (context, index) {
              final quote = quotes[index];
              final quoteData = quote.data() as Map<String, dynamic>;
              final quoteTitle = quoteData['title'] ?? 'No title';
              final quoteDescription = quoteData['description'] ?? 'No description';
              final quoteImage = quoteData['imageUrl'];
              final createdAt = (quoteData['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();

              return ListTile(
                leading: quoteImage != null ? Image.network(quoteImage, width: 50, height: 50) : null,
                title: Text(quoteTitle),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Description: $quoteDescription'),
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
                            builder: (context) => QuoteFormScreen(quoteId: quote.id, quoteData: quoteData),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await deleteQuote(quote.id);
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

class QuoteFormScreen extends StatefulWidget {
  final String? quoteId;
  final Map<String, dynamic>? quoteData;

  const QuoteFormScreen({super.key, this.quoteId, this.quoteData});

  @override
  _QuoteFormScreenState createState() => _QuoteFormScreenState();
}

class _QuoteFormScreenState extends State<QuoteFormScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _imageUrl;
  XFile? _pickedImage;

  @override
  void initState() {
    super.initState();
    if (widget.quoteData != null) {
      _titleController.text = widget.quoteData!['title'] ?? '';
      _descriptionController.text = widget.quoteData!['description'] ?? '';
      _imageUrl = widget.quoteData!['imageUrl'];
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
    final storageRef = FirebaseStorage.instance.ref().child('quote_images/${image.name}');
    await storageRef.putFile(File(image.path));
    return await storageRef.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quoteId == null ? 'Add Quote' : 'Edit Quote'),
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

                final quoteData = {
                  'title': _titleController.text,
                  'description': _descriptionController.text,
                  'imageUrl': imageUrl ?? _imageUrl,
                  'createdAt': FieldValue.serverTimestamp(),
                };
                await const ManageQuotesScreen().addOrUpdateQuote(quoteId: widget.quoteId, quoteData: quoteData);
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
