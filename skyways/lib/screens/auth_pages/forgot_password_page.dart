

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skyways/buttons/elevatedButtons.dart';
import 'package:skyways/utils/utils.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false; // Loading state

  void resetPassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        isLoading = true;
      });

      String email = emailController.text.trim();

      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

        showTopFlushbar(
          context,
          message: 'Password reset email sent to $email',
          backgroundColor: Colors.green,
          icon: Icons.check_circle,
        );
      } on FirebaseAuthException catch (e) {
        String message = 'An error occurred';
        if (e.code == 'user-not-found') {
          message = 'No user found with this email';
        } else if (e.code == 'invalid-email') {
          message = 'The email address is invalid';
        }

        showTopFlushbar(
          context,
          message: message,
          backgroundColor: Colors.red,
          icon: Icons.error,
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: themecolor),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
              Expanded(
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(200),
                    child: Image.asset(LogoPath, fit: BoxFit.cover),
                  ),
               
                ),
              ),
                const SizedBox(height: 30),
          
                Text(
                  'Forgot Password?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: themecolor,
                  ),
                ),
                const SizedBox(height: 10),
          
                const Text(
                  'Enter your email address to reset your password.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 199, 102, 47),
                  ),
                ),
                const SizedBox(height: 30),
          
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: getInputDecoration(
                    'Email Address',
                    Icons.email,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email address';
                    }
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
          
                const SizedBox(height: 30),
          
                CustomButtons.customElevatedButton(
                  text: "Reset Password",
                  onPressed: resetPassword,
                  isLoading: isLoading,
                ),
                const SizedBox(height: 30),
          
                TextButton(
                  onPressed:
                      isLoading
                          ? null
                          : () {
                            Navigator.pop(context);
                          },
                  child: const Text('Back to Login'),
                ),
                SizedBox(height: 70,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
