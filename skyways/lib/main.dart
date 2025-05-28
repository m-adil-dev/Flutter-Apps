import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:skyways/screens/auth_pages/splesh_screen.dart';
import 'package:skyways/chatbot_api_key.dart';
import 'firebase_options.dart';
import 'package:flutter_gemini/flutter_gemini.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  Gemini.init(apiKey: GEMINI_API_KEY);

// insertRandomBookings();  //this is for dummy data insertion 
  runApp(const SkyWaysApp());

}

class SkyWaysApp extends StatelessWidget {
  const SkyWaysApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(useMaterial3: true),

      debugShowCheckedModeBanner: false,
      title: "Sky ways",
      home:  SplashScreen(),
    );
  }
}




