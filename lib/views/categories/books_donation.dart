import 'package:flutter/material.dart';
import 'package:sharecare/common/background_container.dart';
import 'package:sharecare/constants/constants.dart';




class BooksDonationForm extends StatefulWidget {
  const BooksDonationForm({super.key});

  @override
  _BooksDonationFormState createState() => _BooksDonationFormState();
}

class _BooksDonationFormState extends State<BooksDonationForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pickupDateController = TextEditingController();
  final TextEditingController _preferredTimeController = TextEditingController();

  String? _bookCategory;
  String? _vehicleType;
  bool _isAnonymous = false;
  int _quantity = 1;

  final Color turquoise = Colors.teal;

  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(
      color: kOffWhite,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Books Donation'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16.0),
                const Text('Select book category'),
                _buildBookCategorySelector(),
                const SizedBox(height: 16.0),
                _buildBookDetailsField(),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBookCategorySelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: ['Fiction', 'Non-Fiction', 'Children\'s Books'].map((category) {
        return ChoiceChip(
          label: Text(category),
          selected: _bookCategory == category,
          selectedColor: turquoise,
          onSelected: (selected) {
            setState(() {
              _bookCategory = selected ? category : null;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildBookDetailsField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Book Details',
        hintText: 'e.g. 1. "The Great Gatsby" - 5\n2. "To Kill a Mockingbird" - 3',
        border: OutlineInputBorder(),
      ),
      maxLines: 3,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the book details';
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
      // Process the data
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form submitted successfully!')),


     
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => ClothesDonationForm(),
      //   ),
      // );
      );
    }
  }
}