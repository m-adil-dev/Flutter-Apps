import 'package:flutter/material.dart';
import 'package:skyways/utils/utils.dart'; // Make sure you have themecolor defined here

class AboutSkywaysScreen extends StatelessWidget {
  const AboutSkywaysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Skyways"),
        backgroundColor: themecolor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                children: [
                  const TextSpan(text: "About "),
                  TextSpan(
                    text: "Skyways.pk",
                    style: TextStyle(
                      color: themecolor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Skyways.pk has been created to empower the Pakistani traveler with instant bookings and comprehensive choices. It aims to deliver value by offering a range of travel products with the highest standard of service along with cutting-edge technology.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              "Based in Lahore, Pakistan, Skyways.pk is a one-stop shop for all travel-related services. A leading consolidator of travel products, Skyways.pk provides reservation facilities for domestic and international bus tickets, tour packages, and more.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              "With dedicated customer support operating 24/7 and offices in multiple cities across Pakistan, Skyways.pk is there for you, whenever and wherever.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            Text(
              "Our Investors",
              style: TextStyle(
                fontSize: 18,
                color: themecolor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Skyways.pk is part of the Skyways Group which owns Skyways Bus Services, Skyways Tours, and SkyConnect. Skyways is one of the largest travel and transport companies in Pakistan, with a network of over 100 routes and a strong team of professionals dedicated to providing the best in intercity travel. Skyways Tours is a leading provider of domestic and international tour packages, while SkyConnect powers digital innovations for the group.",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
