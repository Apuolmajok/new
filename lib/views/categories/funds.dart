import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:sharecare/models/category_model/funds_model.dart';
import 'package:sharecare/views/home/home_page.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fund Donation',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: FundsPage(),
    );
  }
}

class FundsPage extends StatefulWidget {
  @override
  _FundsPageState createState() => _FundsPageState();
}

class _FundsPageState extends State<FundsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  List<double> _mostDonatedAmounts = [10000.0, 20000.0, 50000.0, 100000.0];
  String _selectedCurrency = 'UGX'; // Default currency

  Future<void> _submitDonation() async {
    if (_formKey.currentState!.validate()) {
      final donation = FundsDonation(
        donorName: _nameController.text,
        amount: double.parse(_amountController.text),
        email: _emailController.text,
        phoneNumber: _phoneController.text,
        message: _messageController.text,
        currency: _selectedCurrency,
        donationDate: DateTime.now(),
      );

      await FirebaseFirestore.instance.collection('funds_donations').add(donation.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thank you for your donation!')),
      );

      _amountController.clear();
      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _messageController.clear();

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fund Donation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Most Donated Amounts',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              _buildMostDonatedAmountsRow(),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: _selectedCurrency,
                items: <String>['USD', 'EUR', 'GBP', 'UGX'] // Add more currencies as needed
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCurrency = newValue!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Select Currency',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _messageController,
                decoration: InputDecoration(
                  labelText: 'Add a message (optional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                maxLines: 3,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: _submitDonation,
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMostDonatedAmountsRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _mostDonatedAmounts.map((amount) {
          return GestureDetector(
            onTap: () {
              _amountController.text = amount.toString();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              margin: const EdgeInsets.only(right: 8.0),
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Text(
                NumberFormat.currency(
                  symbol: 'Ush',
                  decimalDigits: 0,
                ).format(amount),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
