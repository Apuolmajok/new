import 'package:flutter/material.dart';
import 'package:sharecare/constants/constants.dart';
// import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:sharecare/views/authentication/loginpage.dart';
// import 'package:sharecare/views/splash/splash_page.dart';
// import 'package:sharecare/views/authentication/loginpage.dart';
// import 'package:sharecare/views/entrypoint.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  
  @override
  State<SplashScreen> createState() => _SplashScreenState ();
}


class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 10), () {
      // Navigate to the next screen after 5 seconds
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Stack(
      children: [
        Center(
      child: Lottie.asset(
        'assets/anime/sharecare.json',
        repeat: true,
        width: 250,
        height: 250,
        
      ),
      
      ),

      Positioned(
          bottom: 220, // Adjust position as needed
          left: 0,
          right: 0,
          child: Center(
            child: DefaultTextStyle(
              style: const TextStyle(
                color: kPrimary,
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              ),
              child: AnimatedTextKit(
                animatedTexts: [
                  WavyAnimatedText("ShareCare"),
                ],
                isRepeatingAnimation: true,
                
              ),
            ),
          ),
        ),
     

     ],
    );
    
  }
  
}