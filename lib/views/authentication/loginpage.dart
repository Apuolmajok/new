import 'package:flutter/material.dart';
import 'package:sharecare/constants/constants.dart';
import 'package:sharecare/views/Admin_panel/admin.dart';
import 'package:sharecare/views/authentication/forgot_password.dart';
import 'package:sharecare/views/authentication/signup.dart';
import 'package:sharecare/views/entrypoint.dart';
import 'package:sharecare/services/auth_service.dart';
import 'package:sharecare/views/vendor/vendor_admin.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';


class CustomButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final VoidCallback onPressed;
  final double fontSize;

  const CustomButton({
    Key? key,
    required this.text,
    required this.textColor,
    required this.onPressed,
    this.fontSize = 12.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        padding: const EdgeInsets.all(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  final AuthService _authService = AuthService();

  void _login() async {
  final email = _emailController.text;
  final password = _passwordController.text;

  if (email.isEmpty || password.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Please enter both email and password',
          style: TextStyle(color: kSecondary),
        ),
        backgroundColor: kPrimary,
      ),
    );
    return;
  }

  print('Attempting login with email: $email and password: $password');

  try {
    final user = await _authService.signInWithEmailPassword(email, password);
    if (user != null) {
      print('Login successful for user: ${user.userId}');

      // Fetch user role from Firestore
      final userDoc = await _authService.getUserData(user.userId);
      if (userDoc != null) {
        final role = userDoc.role;
        if (role == 'admin') {
          // Redirect to admin panel
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AdminHomeScreen()),
          );
        } else if (role == 'donee') {
          // Fetch vendor ID for donee
          final vendorId = await _authService.getVendorId(user.userId);
          if (vendorId != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => VendorAdminDashboard(vendorId: vendorId)),
            );
          } else {
            // Handle the case where the vendor ID is not found
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Vendor not found.'),
                backgroundColor: kRed,
              ),
            );
          }
        } else {
          // Redirect donors to the main screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
          );
        }
      } else {
        print('User document not found');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'User not found. Please check your credentials or register.',
              style: TextStyle(color: kOffWhite),
            ),
            backgroundColor: kRed,
          ),
        );
      }
    } else {
      print('Login failed');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Login failed. Please check your email and password or verify your email.',
            style: TextStyle(color: kOffWhite),
          ),
          backgroundColor: kRed,
        ),
      );
    }
  } catch (e) {
    print("Login error: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'An error occurred during login. Please try again.',
          style: TextStyle(color: kOffWhite),
        ),
        backgroundColor: kPrimaryLight,
      ),
    );
  }
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
                        'Welcome Back',
                        style: TextStyle(
                          color: kPrimary,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Let us continue donating',
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
                  padding: const EdgeInsets.only(top: 10),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ForgotPasswordPage()), // Replace with your Forgot Password screen
                      );
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                CustomButton(
                  text: 'Login',
                  textColor: kOffWhite,
                 
                  onPressed: _login,
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
                          "Don't have an account?",
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
                                  builder: (context) => const SignUpScreen()),
                            );
                          },
                          child: const Text(
                            'Sign Up',
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
