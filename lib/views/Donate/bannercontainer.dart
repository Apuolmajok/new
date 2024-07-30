import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sharecare/constants/constants.dart';

// ignore: must_be_immutable
class Bannercontainer extends StatelessWidget {
  Bannercontainer({super.key, required this.containerContents});
  
  Widget containerContents;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.33,
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(25.r)
        ),
        child: Container(
          width: width*0.94,
          color: kPrimary,
          child: containerContents,
          // child: SingleChildScrollView(
          //   child: containerContents,
          // ),
        ),
      ),
    );
  }
}
