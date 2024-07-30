import 'package:flutter/material.dart';
import 'package:sharecare/common/custom_container.dart';
import 'package:sharecare/constants/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimary,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(130.h),
          child: Container(
            height: 100,
          )),
      body: SafeArea(
        child: CustomContainer(
          containerContent: Container(
            child: const Text("Cart"),
          ),
        ),
      ),
    );
  }
}
