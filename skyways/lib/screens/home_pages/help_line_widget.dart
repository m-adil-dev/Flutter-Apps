import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:skyways/utils/utils.dart';

class HelpLineWidget extends StatelessWidget {
  const HelpLineWidget({super.key});


  void _makePhoneCall(String phoneNumber) async {
    final Uri url = Uri.parse("tel:$phoneNumber");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }


  void _openWhatsApp(String phoneNumber) async {
    final Uri url = Uri.parse("https://wa.me/$phoneNumber");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void _sendEmail(String email) async {
    final Uri url = Uri.parse("mailto:$email");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            "Connect with us 24/7",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),

        GestureDetector(
          onTap: () => _makePhoneCall("+923161302748"),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(color: themecolor, width: 1),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.add_ic_call_outlined, color: themecolor),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Call us now", style: TextStyle(color: themecolor)),
                    Text(
                      "+923161302748",
                      style: TextStyle(
                        color: themecolor,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: themecolor,
                  size: 15,
                ),
              ],
            ),
          ),
        ),

        // 💬 WhatsApp Support
        GestureDetector(
          onTap: () => _openWhatsApp("923161302748"),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(color: themecolor, width: 1),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.add_ic_call_outlined, color: themecolor),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Whatsapp support", style: TextStyle(color: themecolor)),
                    Text(
                      "+923161302748",
                      style: TextStyle(
                        color: themecolor,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: themecolor,
                  size: 15,
                ),
              ],
            ),
          ),
        ),

        GestureDetector(
          onTap: () => _sendEmail("muhammadadil3383@gmail.com"), // Replace with your actual email
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(color: themecolor, width: 1),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.chat, color: themecolor),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Email support", style: TextStyle(color: themecolor)),
                    Text(
                      "support@skyways.com", // Replace with your email
                      style: TextStyle(
                        color: themecolor,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: themecolor,
                  size: 15,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
