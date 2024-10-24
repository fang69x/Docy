import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:docy/provider/auth_provider.dart';
import 'package:docy/Pages/homePage.dart';
import 'package:docy/Pages/loginPage.dart';
import 'package:docy/Pages/textform.dart';

class SignUpPage extends ConsumerWidget {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  SignUpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.watch(authProvider.notifier); // Auth provider

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Center(
                child: Icon(
                  Icons.person_add,
                  color: Color(0xFFF4B342),
                  size: 80,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Sign up to get started',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 10),

              // Name Input
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "Name",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: nameController,
                hintText: "Enter full name",
                obscureText: false,
                prefixIcon: const Icon(Icons.person, color: Colors.grey),
              ),
              const SizedBox(height: 10),

              // Phone Number Input
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "Phone Number",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: phoneController,
                hintText: "Enter phone number",
                obscureText: false,
                prefixIcon: const Icon(Icons.phone, color: Colors.grey),
              ),
              const SizedBox(height: 10),

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
              const SizedBox(height: 10),

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

              // Confirm Password Input
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "Confirm Password",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: confirmPasswordController,
                hintText: "Re-enter password",
                obscureText: true,
                prefixIcon: const Icon(Icons.lock, color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // Sign Up Button
              SizedBox(
                width: double.maxFinite,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      await authNotifier.signUp(
                        emailController.text,
                        passwordController.text,
                      );
                      // Navigate to Home Page after successful signup
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                      );
                    } catch (e) {
                      // Handle error (show snackbar, etc.)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString())),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFFF4B342), // Add button color
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Add rounded corners
                    ),
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Already have an account? Login link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?",
                      style: TextStyle(fontSize: 14)),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: const Text(
                      " Login",
                      style: TextStyle(color: Color(0xFFF4B342)),
                    ),
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
