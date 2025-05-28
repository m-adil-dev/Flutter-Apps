import 'package:flutter/material.dart';
import 'package:skyways/utils/utils.dart'; // themecolor is assumed to be defined here

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: themecolor,
        ),
      ),
    );
  }

  Widget sectionContent(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 15, height: 1.5),
    );
  }

  Widget bulletList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("• ", style: TextStyle(fontSize: 16)),
              Expanded(child: Text(item, style: const TextStyle(fontSize: 15))),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy Policy"),
        backgroundColor: themecolor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sectionContent(
              "Our Privacy Policy has been created to transparently explain how we collect, use, and safeguard your personal information. Please review it carefully.",
            ),
            const SizedBox(height: 10),
            sectionContent(
              "We understand that privacy and security are of utmost importance and take every reasonable measure to protect both. Skyways follows industry best practices to protect your personal data.",
            ),
            const SizedBox(height: 10),
            sectionContent(
              "Please keep in mind that our Privacy Policy is subject to change periodically and the most recent version will be posted online.",
            ),
            const SizedBox(height: 10),
            sectionContent(
              "As you explore the features of our platform, rest assured that we are committed to safeguarding your sensitive and non-sensitive data.",
            ),

            sectionTitle("Types of Information We Collect"),
            sectionContent("What is Personal Information:"),
            bulletList([
              "Full name",
              "Email address",
              "Mailing address",
              "Phone number",
              "Credit card number",
              "Other information you submit voluntarily",
            ]),

            sectionTitle("Use of Personal Information"),
            sectionContent(
              "Skyways collects personal information for various purposes such as booking tickets, providing support, and improving your experience. This data may also be used to comply with legal obligations, resolve disputes, and enforce agreements.",
            ),

            sectionTitle("Automatic Collection of Non-Personal Information"),
            sectionContent(
              "Some of your actions get 'tracked' such as how long you stayed on a page, your screen size, clicks etc. This non-personal information is collected anonymously to understand customer usage patterns.",
            ),
            bulletList([
              "Type of device used",
              "IP address",
              "Date/time of session",
              "Pages visited by each session",
              "Referrer address (from which you came)",
            ]),

            sectionTitle("Information We Share"),
            sectionContent(
              "Personal information collected and held is never sold to outside parties. However, in the following scenarios, we may share your data:",
            ),
            bulletList([
              "Providing services",
              "Handling customer and support queries",
              "Improving usability",
              "Co-operating with legal authorities",
            ]),
            sectionContent("If such data is shared, it is only with:"),
            bulletList([
              "Travel SaaS platforms",
              "Law enforcement",
              "Service providers",
            ]),

            sectionTitle("Privacy Practices of Third-Party Technologies"),
            sectionContent(
              "We employ technologies such as cookies, analytics, and APIs. These may be operated by Skyways or third-party vendors to enhance the user experience. These services may track anonymous user behavior.",
            ),
            bulletList([
              "Landing URLs clicked",
              "Session duration",
              "User visit patterns",
              "Views and pages",
            ]),

            sectionTitle("Email Communication"),
            sectionContent(
              "We may contact you via email or phone for updates, marketing, or notifications unless you opt-out. You may unsubscribe by following the instructions in our emails.",
            ),

            sectionTitle("Changes to this Privacy Policy"),
            sectionContent(
              "Any changes to our Privacy Policy will be posted on this page with the revised date. Continued usage of our platform constitutes agreement with the updated policy.",
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
