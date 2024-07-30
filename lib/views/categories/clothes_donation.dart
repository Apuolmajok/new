import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sharecare/models/category_model/clothes_model.dart';
import 'package:sharecare/views/categories/funds.dart';

class ClothesDonationForm extends StatefulWidget {
  const ClothesDonationForm({super.key});

  @override
  _ClothesDonationFormState createState() => _ClothesDonationFormState();
}

class _ClothesDonationFormState extends State<ClothesDonationForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _clothesDetailsController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  String? _clothesType;
  String? _vehicleType;
  bool _isAnonymous = false;
  int _quantity = 1;

  Future<void> _submitDonation() async {
    if (_formKey.currentState!.validate()) {
      final donation = ClothesDonation(
        clothesType: _clothesType,
        clothesDetails: _clothesDetailsController.text,
        quantity: _quantity,
        vehicleType: _vehicleType,
        isAnonymous: _isAnonymous,
        message: _messageController.text,
        donationDate: DateTime.now(),
      );

      await FirebaseFirestore.instance.collection('clothes_donations').add(donation.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thank you for your donation!')),
      );

      _clothesDetailsController.clear();
      _messageController.clear();
      setState(() {
        _clothesType = null;
        _vehicleType = null;
        _isAnonymous = false;
        _quantity = 1;
      });

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FundsPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clothes Donation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16.0),
              const Text('Select clothes category'),
              _buildClothesTypeSelector(),
              const SizedBox(height: 16.0),
              _buildClothesDetailsField(),
              const SizedBox(height: 16.0),
              _buildQuantitySelector(),
              const SizedBox(height: 16.0),
              _buildVehicleSelector(),
              const SizedBox(height: 16.0),
              _buildWishMessageField(),
              const SizedBox(height: 16.0),
              _buildAnonymousSwitch(),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitDonation,
                child: const Text('Donate'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClothesTypeSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: ['Men', 'Women', 'Kids'].map((type) {
        return ChoiceChip(
          label: Text(type),
          selected: _clothesType == type,
          selectedColor: Colors.teal,
          onSelected: (selected) {
            setState(() {
              _clothesType = selected ? type : null;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildClothesDetailsField() {
    return TextFormField(
      controller: _clothesDetailsController,
      decoration: const InputDecoration(
        labelText: 'Clothes Details',
        hintText: 'e.g. 1. Men\'s Shirts - 10\n2. Women\'s Dresses - 5\n3. Kids\' Jackets - 8',
        border: OutlineInputBorder(),
      ),
      maxLines: 3,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the clothes details';
        }
        return null;
      },
    );
  }

  Widget _buildQuantitySelector() {
    return Row(
      children: [
        const Text('Quantity'),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () {
            if (_quantity > 1) {
              setState(() {
                _quantity--;
              });
            }
          },
        ),
        Text('$_quantity'),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            setState(() {
              _quantity++;
            });
          },
        ),
      ],
    );
  }

  Widget _buildVehicleSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Vehicle Preference'),
        Row(
          children: [
            const Icon(Icons.motorcycle),
            Radio(
              value: 'Motorcycle',
              groupValue: _vehicleType,
              onChanged: (String? value) {
                setState(() {
                  _vehicleType = value;
                });
              },
            ),
            const Icon(Icons.car_rental),
            Radio(
              value: 'Car',
              groupValue: _vehicleType,
              onChanged: (String? value) {
                setState(() {
                  _vehicleType = value;
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWishMessageField() {
    return TextFormField(
      controller: _messageController,
      decoration: const InputDecoration(
        labelText: 'Add a message (optional)',
        border: OutlineInputBorder(),
      ),
      maxLines: 2,
    );
  }

  Widget _buildAnonymousSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Donate anonymously?'),
        Switch(
          value: _isAnonymous,
          onChanged: (value) {
            setState(() {
              _isAnonymous = value;
            });
          },
        ),
      ],
    );
  }
}
