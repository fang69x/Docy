import 'package:docy/Pages/textform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:docy/Pages/homePage.dart';
import 'package:docy/Pages/signUp.dart';
import 'package:docy/provider/auth_provider.dart';

class LoginPage extends ConsumerWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier =
        ref.watch(authProvider.notifier); // Listen to authProvider

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              const Center(
                child: Icon(
                  Icons.login,
                  color: Color(0xFFF4B342),
                  size: 80,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Please log in to your account',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 40),

              // Email Input
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "Email",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: emailController,
                hintText: "Enter email",
                obscureText: false,
                prefixIcon: const Icon(Icons.email, color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // Password Input
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "Password",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: passwordController,
                hintText: "Enter password",
                obscureText: true,
                prefixIcon: const Icon(Icons.lock, color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {}, // Implement forgot password functionality
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(
                      color: Color(0xFFF4B342),
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Login Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      await authNotifier.signInWithEmail(
                        emailController.text,
                        passwordController.text,
                      );
                      // Navigate to Home Page after successful login
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()));
                    } catch (e) {
                      // Handle error (show snackbar, etc.)
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF4B342), // Button color
                  ),
                  child: const Text('Login',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
              ),
              const SizedBox(height: 20),

              // Google Sign-In Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      await authNotifier.signInWithGoogle();
                      // Navigate to Home Page after successful login
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                      );
                    } catch (e) {
                      // Handle error (show snackbar, etc.)
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  },
                  icon: Image.asset(
                    'lib/images/google.jpeg', // Provide the relative path to your image
                    width: 24, // Adjust size as needed
                    height: 24,
                  ),
                  label: const Text(
                    'Sign in with Google',
                    style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color(0xFFF4B342), // Button background color
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Sign Up Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?",
                      style: TextStyle(fontSize: 14)),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpPage()));
                    },
                    child: const Text(" Sign Up",
                        style: TextStyle(color: Color(0xFFF4B342))),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
