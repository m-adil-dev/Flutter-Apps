
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skyways/screens/BookingsScreens/cancel_bookings.dart';
import 'package:skyways/screens/BookingsScreens/rejected_bookings.dart';
import 'package:skyways/screens/auth_pages/login_page.dart';
import 'package:skyways/screens/home_pages/home_page.dart';
import 'package:skyways/screens/infoScreen/AboutSkywaysScreen.dart';
import 'package:skyways/screens/infoScreen/PrivacyPolicyScreen.dart';
import 'package:skyways/screens/infoScreen/SkywaysTermsScreen.dart';
import 'package:skyways/utils/utils.dart';


class CustomUserDrawer extends StatelessWidget {
  const CustomUserDrawer({super.key});

  String capitalizeFirstLetter(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    String displayName = user?.displayName ?? 'User';
    displayName = displayName
        .split(' ')
        .map((word) => capitalizeFirstLetter(word))
        .join(' ');

    String email = user?.email ?? 'No email';

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: themecolor),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: themecolor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        email,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // List items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 0),
              children: [
                CustomDrawerTile(
                  icon: Icons.airplane_ticket_outlined,
                  title: 'Bookings',
                  onTap: (){
                    
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage(isStateBooking: true)),
                    );
                  },
                ),
                CustomDrawerTile(
                  icon: Icons.money_off_csred,
                  title: 'Refund Claims',
                  onTap: ()  {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserCancelBookings()),
                    );
                  },
                ),
                CustomDrawerTile(
                  icon: Icons.cancel_schedule_send_outlined,
                  title: 'Rejected Bookings',
                  onTap: ()  {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserRejectedBookings()),
                    );
                  },
                ),
                CustomDrawerTile(
                  icon: Icons.info_outline,
                  title: 'About skyways.pk',
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> AboutSkywaysScreen()));
                  },
                ),
                CustomDrawerTile(
                  icon: Icons.article_outlined,
                  title: 'Terms & Conditions',
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> SkywaysTermsScreen()));
                  },
                ),
                CustomDrawerTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> PrivacyPolicyScreen()));
                  },  
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Logout
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: CustomDrawerTile(
              icon: Icons.logout,
              title: 'Logout',
              isLogout: true,
              onTap: () async {
                showLoadingDialog(context);
                await FirebaseAuth.instance.signOut();
                await FirebaseAuth.instance.authStateChanges().firstWhere((user) => user == null);
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CustomDrawerTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final bool isLogout;

  const CustomDrawerTile({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
    this.isLogout = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color iconBgColor =
        isLogout ? Colors.red.shade100 : themecolor.withOpacity(0.15);
    final Color iconColor = isLogout ? Colors.red : themecolor;

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(color: iconBgColor, shape: BoxShape.circle),
        child: Icon(icon, size: 20, color: iconColor),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: isLogout ? Colors.red : Colors.black87,
          fontWeight: isLogout ? FontWeight.w500 : FontWeight.normal,
        ),
      ),
      trailing: isLogout ? null : const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
      splashColor: Colors.grey.shade200,
    );
  }
}