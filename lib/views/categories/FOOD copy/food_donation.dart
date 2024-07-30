import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sharecare/common/app_style.dart';
import 'package:sharecare/common/reusabletext.dart';
import 'package:sharecare/constants/constants.dart';
import 'package:sharecare/models/category_model/food_model.dart';
import 'package:sharecare/views/categories/FOOD%20copy/confirmation_page.dart';

class FoodDonationForm extends StatefulWidget {
  const FoodDonationForm({super.key});

  @override
  _FoodDonationFormState createState() => _FoodDonationFormState();
}

class _FoodDonationFormState extends State<FoodDonationForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _foodItemsController = TextEditingController();
  final TextEditingController _cookedDateController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _wishMessageController = TextEditingController();
  final DateFormat _dateFormat = DateFormat('dd.MM.yyyy, hh:mm a');

  String? _selectedSource;
  String? _foodType;
  String? _vehicleType;
  bool _isAnonymous = false;
  int _quantity = 1;

  Future<void> _submitDonation() async {
    if (_formKey.currentState!.validate()) {
      final cookedDate = _dateFormat.parse(_cookedDateController.text);
      final expiryDate = _dateFormat.parse(_expiryDateController.text);

      final donation = FoodDonation(
        source: _selectedSource,
        foodType: _foodType,
        foodItems: _foodItemsController.text,
        cookedDate: cookedDate,
        expiryDate: expiryDate,
        quantity: _quantity,
        vehicleType: _vehicleType,
        isAnonymous: _isAnonymous,
        wishMessage: _wishMessageController.text,
        donationDate: DateTime.now(),
      );

      await FirebaseFirestore.instance.collection('food_donations').add(donation.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thank you for your donation!')),
      );

      _foodItemsController.clear();
      _cookedDateController.clear();
      _expiryDateController.clear();
      _wishMessageController.clear();
      setState(() {
        _selectedSource = null;
        _foodType = null;
        _vehicleType = null;
        _isAnonymous = false;
        _quantity = 1;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmationPage(
            selectedSource: _selectedSource,
            foodType: _foodType,
            vehicleType: _vehicleType,
            quantity: _quantity,
            isAnonymous: _isAnonymous,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ReusableText(
          text: "Food Donation",
          style: appStyle(20, kDark, FontWeight.w600),
        ),
        backgroundColor: kPrimary,
      ),
      body: Container(
        color: kOffWhite,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const Text('Select Source of Food'),
                _buildSourceSelector(),
                const SizedBox(height: 16.0),
                const Text('Food Type'),
                _buildFoodTypeSelector(),
                const SizedBox(height: 16.0),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: kGrayLight),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: _buildFoodItemsField(),
                ),
                const SizedBox(height: 16.0),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: kPrimaryLight),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: _buildDateTimePicker('Cooked Date & Time', _cookedDateController),
                ),
                const SizedBox(height: 10.0, width: 10),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: kPrimaryLight),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: _buildDateTimePicker('Expiry Date & Time', _expiryDateController),
                ),
                const SizedBox(height: 16.0),
                _buildQuantitySelector(),
                const SizedBox(height: 16.0),
                _buildVehicleSelector(),
                const SizedBox(height: 16.0),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: kPrimaryLight),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: _buildWishMessageField(),
                ),
                const SizedBox(height: 16.0),
                _buildAnonymousSwitch(),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _submitDonation,
                  child: const Text('Next'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSourceSelector() {
    return Wrap(
      spacing: 8.0,
      children: ['Home', 'Restaurants', 'Events', 'Others'].map((source) {
        return ChoiceChip(
          label: Text(source),
          selected: _selectedSource == source,
          selectedColor: kPrimaryLight,
          onSelected: (selected) {
            setState(() {
              _selectedSource = selected ? source : null;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildFoodTypeSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: ['Veg', 'Non-Veg', 'Veg & Non-Veg'].map((type) {
        return ChoiceChip(
          label: Text(type),
          selected: _foodType == type,
          selectedColor: kPrimaryLight,
          onSelected: (selected) {
            setState(() {
              _foodType = selected ? type : null;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildFoodItemsField() {
    return TextFormField(
      controller: _foodItemsController,
      decoration: const InputDecoration(
        labelText: 'Food Items',
        hintText: 'e.g. 1. Rice - 5kg\n2. Sambar - 6 liters\n3. Potato fries - 4kg',
        border: OutlineInputBorder(),
      ),
      maxLines: 3,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the food items';
        }
        return null;
      },
    );
  }

  Widget _buildDateTimePicker(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () => _selectDateTime(controller),
        ),
      ),
      readOnly: true,
    );
  }

  Future<void> _selectDateTime(TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(picked),
      );
      if (time != null) {
        final DateTime fullDateTime = DateTime(
          picked.year, picked.month, picked.day, time.hour, time.minute);
        controller.text = _dateFormat.format(fullDateTime);
      }
    }
  }

  Widget _buildQuantitySelector() {
    return Row(
      children: [
        const Text('Food Quantity'),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          color: kPrimaryLight,
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
          icon: const Icon(Icons.add_circle_outline),
          color: kPrimaryLight,
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
        const Text('Type of vehicle needed?'),
        Row(
          children: [
            const Icon(Icons.pedal_bike),
            Radio(
              value: 'Bike',
              groupValue: _vehicleType,
              onChanged: (String? value) {
                setState(() {
                  _vehicleType = value;
                });
              },
              activeColor: kPrimaryLight,
            ),
            const Icon(Icons.directions_car),
            Radio(
              value: 'Car',
              groupValue: _vehicleType,
              onChanged: (String? value) {
                setState(() {
                  _vehicleType = value;
                });
              },
              activeColor: kPrimaryLight,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWishMessageField() {
    return TextFormField(
      controller: _wishMessageController,
      decoration:const  InputDecoration(
        labelText: 'Do you want to send a wish message?',
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
          activeColor: kPrimaryLight,
        ),
      ],
    );
  }
}
