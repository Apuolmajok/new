import 'package:flutter/material.dart';
import 'package:sharecare/constants/constants.dart';


class CustomButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? textColor;

  const CustomButton({
    Key? key,
    this.text,
    this.onPressed,
    this.color,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16),
        iconColor: Colors.blue,
      ),
      child: const Text(
        "View Details",
        style:TextStyle(color: kPrimary),
        ),
    );
  }
}
