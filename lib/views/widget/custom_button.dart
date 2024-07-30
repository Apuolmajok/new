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
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        height: 40,
        width: 150,
        decoration: BoxDecoration(
          color: kPrimary,
          border: Border.all(width: 1, color: kPrimary),
          borderRadius: BorderRadius.circular(30),

        ),
        child:  Center(
          child: Text(
            text!,
            style: TextStyle(color: textColor, fontSize: 25),
        )
      ),

     )
    );
  }
}
