import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sharecare/common/app_style.dart';
import 'package:sharecare/common/reusabletext.dart';
import 'package:sharecare/constants/constants.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      height: 110.h,
      color: kOffWhite,
      child: Container(
        margin: EdgeInsets.only(top: 20.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
            
                CircleAvatar(
                  radius: 22.r,
                  backgroundColor: kSecondary,
                  backgroundImage: const NetworkImage("https://www.freepik.com/free-photo/smart-young-businessman-looking-computer-office_8989549.htm#fromView=search&page=1&position=24&uuid=7e395642-4d80-46bf-b4cf-f3ff1314f7ab"),
                  
                ),
            
            
                Padding(
                  padding: EdgeInsets.only(bottom: 6.h, left: 8.w ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ReusableText(text: "Donate to", style: appStyle(13, kSecondary, FontWeight.w600)),
                      SizedBox(
                        width: width*0.65,
                        child: Text(
                          "Babies Home Nsambya, plot 233",
                          overflow: TextOverflow.ellipsis,
                          style: appStyle(11, kGrayLight, FontWeight.normal),
                        ),
                      ),
            
                    
            
                    ],
            
                  ),
                ),
               
              ],
            ),
             Text(getTimeOfDay(), style: const TextStyle(fontSize: 25),)
          ],
        ),
      ),
    );
  }

  String getTimeOfDay(){
    DateTime now = DateTime.now();
    int hour = now.hour;

    if(hour>=0 && hour < 12){
      return " ☀️ ";
    }else if(hour>=12 && hour < 16){
      return " ⛅ ";
    }else{
      return " 🌙 ";
    }
  }
}