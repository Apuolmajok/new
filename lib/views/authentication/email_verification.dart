import 'package:flutter/material.dart';
import 'package:sharecare/constants/constants.dart';
import 'package:sharecare/views/authentication/loginpage.dart';
//import 'package:sharecare/views/entrypoint.dart';


class EmailverificationPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
    EmailverificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:kPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            ); 
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Center(
                    child: const Text(
                    'Verify Your Email',
                    style: TextStyle(
                      fontSize: 40, // Font size for the title
                      fontWeight: FontWeight.bold, // Bold text for the title
                    ),
                  ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'In order to protect your privacy and security, we have sent you a verification email. Please check your email now.',
                    style: TextStyle(
                      fontSize: 16, // Font size for the description
                      color: Colors.grey[700], // Text color
                    ),
                  ),
                  
                  
                  
                  const SizedBox(height: 32),
                  
                    CustomButton(
                  text: 'After confirming your email, then click here to login',
                  textColor: kOffWhite,
                 
                  onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    },
                ),
                  
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
