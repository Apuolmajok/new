import 'package:flutter/material.dart';
import 'package:sharecare/constants/constants.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kOffWhite,
        title: const Text('Category page'),
      ),

      body: Center(
        child: Text('Category Page'),
      ),
    );
  }
}