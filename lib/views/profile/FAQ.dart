import 'package:flutter/material.dart';
import 'package:sharecare/constants/constants.dart';
import 'package:sharecare/views/profile/drawer.dart';

class FAQScreen extends StatelessWidget {
  final List<Map<String, String>> faqs = [
    {
      "question": "What is this app about?",
      "answer":
          "This app is designed to help users make donations to various causes and track their contributions efficiently."
    },
    {
      "question": "How do I make a donation?",
      "answer":
          "To make a donation, click on the donate icon at the bottom of the home screen and follow prompts to select a cause and enter the necessary details."
    },
    {
      "question": "How can I edit my donation details?",
      "answer":
          "To edit your donation details, go to My Donations' details and select the donation that you want to edit."
    },
    {
      "question": "How do I cancel a donation?",
      "answer":
          "To cancel a donation, go to My Donations and select the donation that you want to cancel and confirm cancellation."
    },
    {
      "question": "How do I reset my password?",
      "answer":
          "To reset your password, go to the Profile screen and click on 'Forgot Password'. Follow the instructions to reset your password."
    },
    {
      "question": "Can I customize the app theme?",
      "answer":
          "Yes, you can customize the app theme by going to the Settings screen and selecting your preferred theme."
    },
    {
      "question": "How do I contact support?",
      "answer":
          "To contact support, visit the Contact Us page in the app and fill out the contact form or send an email to sharecare@gmail.com."
    },
    {
      "question": "Where can I find more information about the app?",
      "answer":
          "More information can be found on our website at www.sharecare.com."
    },
  ];


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
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Frequently Asked Questions',
                  style: TextStyle(
                    fontSize: 35, // Font size for the title
                    fontWeight: FontWeight.bold, // Bold text for the title
          
                  ),
                ),
              ),
              Expanded(
                child: FAQList(
                    faqs: faqs), // Pass the FAQ data to the FAQList widget
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FAQList extends StatefulWidget {
  final List<Map<String, String>> faqs;

  FAQList({required this.faqs});

  @override
  _FAQListState createState() => _FAQListState();
}

class _FAQListState extends State<FAQList> {
  late List<bool> _isOpen;

  @override
  void initState() {
    super.initState();
    _isOpen = List<bool>.filled(widget.faqs.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      shrinkWrap:
          true, // This allows the ListView to take up only as much space as needed
      itemCount: widget.faqs.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ExpansionPanelList(
            elevation: 1,
            expandedHeaderPadding: const EdgeInsets.all(0),
            animationDuration: const Duration(milliseconds: 500),
            expansionCallback: (panelIndex, isExpanded) {
              setState(() {
                _isOpen[index] = !_isOpen[index];
              });
            },
            children: [
              ExpansionPanel(
                headerBuilder: (context, isExpanded) {
                  return ListTile(
                    title: Text(
                      widget.faqs[index]["question"]!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold, // Bold text for questions
                      ),
                    ),
                  );
                },
                body: ListTile(
                  title: Text(widget.faqs[index]["answer"]!),
                ),
                isExpanded: _isOpen[index],
              ),
            ],
          ),
        );
      },
    );
  }
}
