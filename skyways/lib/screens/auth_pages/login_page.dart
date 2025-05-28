import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skyways/screens/AdminScreens/Admin_dashboard.dart';
import 'package:skyways/screens/auth_pages/forgot_password_page.dart';
import 'package:skyways/screens/auth_pages/sign_up_page.dart';
import 'package:skyways/buttons/elevatedButtons.dart';
import 'package:skyways/screens/home_pages/home_page.dart';
import 'package:skyways/utils/utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;
  bool isLoginLoading = false;

  Future<void> loginUser() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => isLoginLoading = true);

      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        showTopFlushbar(
          context,
          message: 'Login successful',
          backgroundColor: Colors.green,
          icon: Icons.check_circle,
        );

        if(emailController.text.trim() == "m.adil.pirzada@gmail.com"){

        Navigator.push(context, MaterialPageRoute(builder: (context)=> AdminDashboard()));
        }
        else{
        Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage(isStateBooking: false,)));

        }
      } on FirebaseAuthException catch (e) {
        String message = 'Login failed';
        if (e.code == 'user-not-found') {
          message = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          message = 'Wrong password provided.';
        }

        showTopFlushbar(
          context,
          message: message,
          backgroundColor: Colors.red,
          icon: Icons.error,
        );
      } finally {
        setState(() => isLoginLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      borderRadius: BorderRadius.circular(400),
                      child: Image.asset(LogoPath, fit: BoxFit.cover),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Email field
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: getInputDecoration('Email', Icons.email),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Password field
                TextFormField(
                  controller: passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: getInputDecoration(
                    'Password',
                    Icons.lock,
                    isPassword: true,
                    toggleVisibility: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                    isVisible: _isPasswordVisible,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // Forgot password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordPage(),
                        ),
                      );
                    },
                    child: const Text('Forgot Password?'),
                  ),
                ),
                const SizedBox(height: 20),

                CustomButtons.customElevatedButton(
                  text: "Login",
                  onPressed: loginUser,
                  isLoading: isLoginLoading,
                ),

                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const SignUpPage(),
                          ),
                        );
                      },
                      child: const Text('Sign Up'),
                    ),
                  ],
                ),
                SizedBox(height: 70),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
