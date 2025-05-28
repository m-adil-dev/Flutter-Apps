import 'package:flutter/material.dart';
import 'package:skyways/screens/AdminScreens/admin_analytics_screen.dart';
import 'package:skyways/screens/AdminScreens/admin_dreawer.dart';
import 'package:skyways/utils/utils.dart';


class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sky ways Admin Dashboard",style: TextStyle(color: themecolor),),
        backgroundColor: Colors.white,
        centerTitle: true,
        foregroundColor: themecolor
        
      ),
      drawer: CustomAdminDrawer(),
      body:AdminAnalyticsScreen(),

    );
  }
}



