import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:sharecare/constants/constants.dart';
import 'package:sharecare/views/authentication/email_verification.dart';
import 'package:sharecare/views/authentication/loginpage.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:sharecare/services/auth_service.dart';
import 'package:sharecare/views/vendor/vendor_rigistration_form.dart';
// Page to ask for business registration or go to the dashboard

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _obscureText = true;
  final AuthService _authService = AuthService();
  String _selectedRole = 'donor';

  void _signUp() async {
    final name = _nameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill out all fields'),
        ),
      );
      return;
    } else if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Passwords do not match',
            style: TextStyle(color: kSecondary),
          ),
          backgroundColor: kPrimary,
        ),
      );
      return;
    }

    try {
      auth.User? user = await _authService.registerWithEmailPassword(name, email, password, _selectedRole);
      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Registration successful. Please verify your email.',
              style: TextStyle(color: kSecondary),
            ),
            backgroundColor: kPrimary,
          ),
        );
        if (_selectedRole == 'donee') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => VendorRegistrationScreen(userId: user.uid)),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => EmailverificationPage()),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Registration failed',
              style: TextStyle(color: kOffWhite),
            ),
            backgroundColor: kRed,
          ),
        );
      }
    } catch (e) {
      print("Sign up error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'An error occurred during registration: $e',
            style: TextStyle(color: kOffWhite),
          ),
          backgroundColor: kPrimaryLight,
        ),
      );
    }
  }

  void _verifyPhone() async {
    final phone = _phoneController.text;
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your phone number'),
        ),
      );
      return;
    }

    await _authService.verifyPhoneNumber(phone, (auth.PhoneAuthCredential credential) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Verification code sent. Please check your phone.',
            style: TextStyle(color: kSecondary),
          ),
          backgroundColor: kPrimary,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 50.0),
                  child: Column(
                    children: [
                      Text(
                        'Welcome Onboard',
                        style: TextStyle(
                          color: kPrimary,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Let us help you donate easily',
                        style: TextStyle(
                          color: kGray,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 15.0, bottom: 20, left: 20, right: 20),
                  child: TextField(
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    autocorrect: true,
                    enableSuggestions: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color.fromARGB(255, 235, 233, 233)),
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      ),
                      fillColor: Color.fromARGB(255, 235, 233, 233),
                      filled: true,
                      hintText: 'Enter your name',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 15.0, bottom: 20, left: 20, right: 20),
                  child: TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: true,
                    enableSuggestions: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color.fromARGB(255, 235, 233, 233)),
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      ),
                      fillColor: Color.fromARGB(255, 235, 233, 233),
                      filled: true,
                      hintText: 'Enter your email',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 10.0, bottom: 20, left: 20, right: 20),
                  child: TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      ),
                      fillColor: Color.fromARGB(255, 235, 233, 233),
                      filled: true,
                      hintText: 'Enter your phone number',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 10.0, bottom: 20, left: 20, right: 20),
                  child: TextField(
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _obscureText,
                    autocorrect: false,
                    enableSuggestions: false,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(_obscureText ? Ionicons.ios_eye_off : Ionicons.ios_eye_sharp),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      ),
                      fillColor: const Color.fromARGB(255, 235, 233, 233),
                      filled: true,
                      hintText: 'Enter your Password',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 10.0, bottom: 20, left: 20, right: 20),
                  child: TextField(
                    controller: _confirmPasswordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _obscureText,
                    autocorrect: false,
                    enableSuggestions: false,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(_obscureText ? Ionicons.ios_eye_off : Ionicons.ios_eye_sharp),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      ),
                      fillColor: const Color.fromARGB(255, 235, 233, 233),
                      filled: true,
                      hintText: 'Confirm Password',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 10.0, bottom: 20, left: 20, right: 20),
                  child: DropdownButtonFormField<String>(
                    value: _selectedRole,
                    items: const [
                      DropdownMenuItem(value: 'donor', child: Text('User')),
                      DropdownMenuItem(value: 'donee', child: Text('NGO')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedRole = value!;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Role',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      ),
                      fillColor: Color.fromARGB(255, 235, 233, 233),
                      filled: true,
                    ),
                  ),
                ),
                CustomButton(
                  text: 'Sign Up',
                  textColor: kOffWhite,
                  onPressed: _signUp,
                ),
                
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    'or Continue with',
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 15,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 40,
                        width: 70,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            MaterialIcons.facebook,
                            color: Colors.black,
                          ),
                          onPressed: () {},
                        ),
                      ),
                      Container(
                        height: 40,
                        width: 70,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            AntDesign.google,
                            color: Colors.black,
                          ),
                          onPressed: () {},
                        ),
                      ),
                      Container(
                        height: 40,
                        width: 70,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            AntDesign.twitter,
                            color: Colors.black,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, left: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(width: 5),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                            );
                          },
                          child: const Text(
                            'Log In',
                            style: TextStyle(
                              color: kPrimary,
                              fontSize: 15,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
