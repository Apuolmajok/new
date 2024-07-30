import 'package:flutter/material.dart';
import 'package:sharecare/views/entrypoint.dart';
  // Ensure the file name matches

class BabyDonationForm extends StatefulWidget {
  const BabyDonationForm({super.key});

  @override
  _BabyDonationFormState createState() => _BabyDonationFormState();
}

class _BabyDonationFormState extends State<BabyDonationForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pickupDateController = TextEditingController();
  final TextEditingController _preferredTimeController = TextEditingController();

  String? _selectedSource;
  String? _booksType;
  String? _vehicleType;
  bool _isAnonymous = false;
  int _quantity = 1;

  final Color turquoise = Colors.teal;

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
              _buildBabyTypeSelector(),
              const SizedBox(height: 16.0),
              _buildBabyDetailsField(),
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
                onPressed: _submitForm,
                child: const Text('Donate'),

              ),
            
              // ElevatedButton(
              //     onPressed: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(builder: (context) => FundsPage()),
                    
              //       );
              //     },
              //     child: Text('go to funds donation'),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBabyTypeSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: ['pampers', 'babyfood', 'toys', 'clothes'].map((type) {
        return ChoiceChip(
          label: Text(type),
          selected: _booksType == type,
          selectedColor: turquoise,
          onSelected: (selected) {
            setState(() {
              _booksType = selected ? type : null;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildBabyDetailsField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Edit some details',
        hintText:
            'e.g. powdered milk (5tins or packets)',
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
      decoration: const InputDecoration(
        labelText: 'Add a message (optional)',
        hintText: 'hope this helps ',
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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Process the data and navigate to the next page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form submitted successfully!')),
      );
    }
  }
}
