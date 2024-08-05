import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sharecare/views/categories/widget/babyconfirm.dart';
import 'package:sharecare/views/entrypoint.dart';


class BabyDonationForm extends StatefulWidget {
  const BabyDonationForm({super.key});

  @override
  _BabyDonationFormState createState() => _BabyDonationFormState();
}

class _BabyDonationFormState extends State<BabyDonationForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _babyDetailsController = TextEditingController();
  final TextEditingController _wishMessageController = TextEditingController();

  String? _selectedType;
  String? _vehicleType;
  bool _isAnonymous = false;
  int _quantity = 1;

  final Color turquoise = Colors.teal;

  void _submitDonation(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final donation = {
        'category': 'Babycare',
        'type': _selectedType,
        'details': _babyDetailsController.text,
        'quantity': _quantity,
        'vehicleType': _vehicleType,
        'isAnonymous': _isAnonymous,
        'wishMessage': _wishMessageController.text,
        'donationDate': DateTime.now(),
      };

      await FirebaseFirestore.instance.collection('donations').add(donation);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thank you for donating these baby care items!')),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }

  void _navigateToConfirmation() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmationPage4(
          type: _selectedType,
          vehicleType: _vehicleType,
          quantity: _quantity,
          isAnonymous: _isAnonymous,
        ),
      ),
    ).then((value) {
      if (value == true) {
        _submitDonation(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Babycare Donation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16.0),
              const Text('Select items to donate'),
              _buildTypeSelector(),
              const SizedBox(height: 16.0),
              _buildDetailsField(),
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
                onPressed: _navigateToConfirmation,
                child: const Text('Donate'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: ['Pampers', 'Babyfood', 'Toys', 'Clothes'].map((type) {
        return ChoiceChip(
          label: Text(type),
          selected: _selectedType == type,
          selectedColor: turquoise,
          onSelected: (selected) {
            setState(() {
              _selectedType = selected ? type : null;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildDetailsField() {
    return TextFormField(
      controller: _babyDetailsController,
      decoration: const InputDecoration(
        labelText: 'Edit some details',
        hintText: 'e.g. powdered milk (5 tins or packets)',
        border: OutlineInputBorder(),
      ),
      maxLines: 3,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some details';
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
      controller: _wishMessageController,
      decoration: const InputDecoration(
        labelText: 'Add a message (optional)',
        hintText: 'Hope this helps',
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
