import 'package:flutter/material.dart';
import 'package:sharecare/constants/constants.dart';
import 'package:sharecare/views/profile/drawer.dart';




class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

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
              MaterialPageRoute(builder: (context) => const AppPage()),
            ); // Navigate back to the previous screen
          },
        ),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
                    child:
            Text(
              'Terms of Service',
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
            ),
            SizedBox(height: 16),
            Text(
              'Introduction',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Welcome to ShareCare. Adonation app whose aim is to improve lives and incraee sustainanbility. By accessing or using ShareCare, you agree to comply with and be bound by these Terms of Service ("Terms"). Please read these Terms carefully before using the app.',
            ),
            SizedBox(height: 16),
            Text(
              'Donations',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'To make a donation through our App, you agree to provide accurate and complete information. All donations are final and non-refundable unless otherwise. We ensure that all donations are used for the intended purposes as described in the App. However, we do not guarantee the outcome of any cause.',
            ),
            SizedBox(height: 16),
            Text(
              'User Accounts',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'To access certain features, you may need to create an account. You agree to provide accurate, complete, and current information during registration. In regards, to account security, you are responsible for maintaining the confidentiality of your account information and for all activities that occur under your account.',
            ),
            SizedBox(height: 16),
            Text(
              'Intellectual Property',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'All content and materials on ShareCare, including but not limited to text, graphics, logos, and software, are the property of ShareCare or its licensors and are protected by applicable intellectual property laws.',
            ),
            SizedBox(height: 16),
            Text(
              'Contact Information',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'If you have any questions about these Terms, please contact us at sharecare@gmail.com.',
            ),
          ],
        ),
      ),
    );
  }
}

