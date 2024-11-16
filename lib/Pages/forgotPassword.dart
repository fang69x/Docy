import 'package:docy/buttons/customelevated.dart';
import 'package:docy/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  late AnimationController _animationController; // Use late keyword

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward(); // Ensure this is initialized before usage
  }

  @override
  void dispose() {
    _emailController.dispose();
    _animationController.dispose(); // Dispose controller to prevent leaks
    super.dispose();
  }

  void _resetPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your email.")),
      );
      return;
    }
    try {
      await _auth.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Password reset email sent! Check your inbox.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 137, 74, 226),
                Color.fromARGB(255, 1, 10, 26)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FadeTransition(
                  opacity: _animationController
                      .drive(CurveTween(curve: Curves.easeIn)),
                  child: Lottie.asset(
                    'lib/assets/lottie/smartphone-unlock.json',
                    height: 200,
                  ),
                ),
                const SizedBox(height: 25),
                const Text(
                  "Forgot Password?",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Enter your email address to receive a password reset link.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color.fromARGB(179, 218, 215, 215)),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "Email Address",
                    labelStyle: const TextStyle(
                        color: Color.fromARGB(255, 129, 128, 126)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                CustomElevatedButton(
                  onPressed: _resetPassword,
                  label: "Reset Password", // The label for the button text
                  icon: null, // Optional: You can add an icon here if needed
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Back to Login",
                    style: TextStyle(color: Color.fromARGB(255, 220, 220, 220)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
