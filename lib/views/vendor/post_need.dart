import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:sharecare/constants/constants.dart';
import 'package:sharecare/views/vendor/models/need_model.dart';

class PostNeedPage extends StatefulWidget {
  final String vendorId;

  const PostNeedPage({required this.vendorId, Key? key}) : super(key: key);

  @override
  _PostNeedPageState createState() => _PostNeedPageState();
}

class _PostNeedPageState extends State<PostNeedPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController(); // Added controller for imageUrl
  final TextEditingController _dateController = TextEditingController(); // Added controller for date
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final need = Need(
        needId: '',
        title: _titleController.text,
        description: _descriptionController.text,
        imageUrl: _imageUrlController.text, // Added imageUrl
        date: DateTime.parse(_dateController.text), // Added date
        vendorId: widget.vendorId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await FirebaseFirestore.instance.collection('needs').add(need.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Need posted successfully!')),
      );

      Navigator.pop(context);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = _dateFormat.format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post a Need'),
        backgroundColor: kPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(_titleController, 'Need Title', 'Enter need title'),
              _buildTextField(_descriptionController, 'Need Description', 'Enter need description'),
              _buildTextField(_imageUrlController, 'Image URL', 'Enter image URL'), // Added field for imageUrl
              _buildDateField(_dateController, 'Date'), // Added field for date
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDateField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: 'Enter date',
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
        readOnly: true,
      ),
    );
  }
}
