import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skyways/screens/auth_pages/login_page.dart';
import 'package:skyways/buttons/elevatedButtons.dart';
import 'package:skyways/utils/utils.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController(); 
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isSingUPLoading = false;

Future<void> signUpUser() async {
  if (_formKey.currentState?.validate() ?? false) {
    setState(() {
      _isSingUPLoading = true;
    });

    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (password != confirmPassword) {
      setState(() {
        _isSingUPLoading = false;
      });
      showTopFlushbar(
        context,
        message: "Passwords do not match",
        backgroundColor: Colors.red,
        icon: Icons.error,
      );
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

      await userCredential.user?.updateDisplayName(name);
      await FirebaseAuth.instance.signOut();

      showTopFlushbar(
        context,
        message: "Account created successfully!",
        backgroundColor: Colors.green,
        icon: Icons.check_circle,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Something went wrong';
      if (e.code == 'email-already-in-use') {
        errorMessage = 'Your email is already registered. Please login.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'Password should be at least 6 characters.';
      } else {
        errorMessage = e.message ?? errorMessage;
      }

      showTopFlushbar(
        context,
        message: "Error: $errorMessage",
        backgroundColor: Colors.red,
        icon: Icons.error,
      );
    } catch (e) {
      showTopFlushbar(
        context,
        message: "Unexpected error: $e",
        backgroundColor: Colors.red,
        icon: Icons.error,
      );
    } finally {
      setState(() {
        _isSingUPLoading = false;
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
          
                // Name Field
                TextFormField(
                  controller: nameController,
                  decoration: getInputDecoration('Full Name', Icons.person),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Please enter your full name'
                              : null,
                ),
                const SizedBox(height: 20),
          
                // Email Field
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: getInputDecoration(
                    'Email Address',
                    Icons.email,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
          
                // Password Field
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
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Please enter a password'
                              : null,
                ),
                const SizedBox(height: 20),
          
                // Confirm Password Field
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: !_isConfirmPasswordVisible,
                  decoration: getInputDecoration(
                    'Confirm Password',
                    Icons.lock_outline,
                    isPassword: true,
                    toggleVisibility: () {
                      setState(() {
                        _isConfirmPasswordVisible =
                            !_isConfirmPasswordVisible;
                      });
                    },
                    isVisible: _isConfirmPasswordVisible,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
          
          CustomButtons.customElevatedButton(text: "Sign Up",onPressed: signUpUser, isLoading: _isSingUPLoading),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      child: const Text('Login'),
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
