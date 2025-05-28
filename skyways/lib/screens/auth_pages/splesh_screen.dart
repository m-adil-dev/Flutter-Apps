import 'package:flutter/material.dart';
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:skyways/screens/AdminScreens/Admin_dashboard.dart';
import 'package:skyways/screens/auth_pages/login_page.dart';
import 'package:skyways/screens/home_pages/home_page.dart';
import 'package:skyways/utils/utils.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
MaterialPageRoute(
  builder: (context) {
    if (user == null) {
      return LoginPage();
    } 
    else if (user.email == "m.adil.pirzada@gmail.com") {
      return AdminDashboard();
    } 
    else {
      return HomePage(isStateBooking: false,);
    }
  },
)
      );
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themecolor,
      body: Center(
        child: Image.asset(LogoPath),
      ),
    );
  }
}

