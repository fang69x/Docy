import 'package:docy/Pages/forgotPassword.dart';
import 'package:docy/Pages/textform.dart';
import 'package:docy/buttons/CustomElevated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:docy/Pages/homePage.dart';
import 'package:docy/Pages/signUp.dart';
import 'package:docy/provider/auth_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends ConsumerWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.watch(authProvider.notifier);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 137, 74, 226),
              Color.fromARGB(255, 1, 10, 26)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.08, vertical: screenHeight * 0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: SizedBox(
                    height: 100.h,
                    width: 120.w,
                    child: Lottie.asset(
                      'lib/assets/lottie/Logging In.json',
                      fit: BoxFit.contain,
                      repeat: true,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                const Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 10.h),
                const Text(
                  'Please log in to your account',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 40.h),

                // Email Input
                _buildSectionTitle("Email"),
                SizedBox(height: 3.h),
                MyTextField(
                  controller: emailController,
                  hintText: "Enter email",
                  obscureText: false,
                  prefixIcon: const Icon(Icons.email, color: Colors.grey),
                ),
                SizedBox(height: 20.h),

                // Password Input
                _buildSectionTitle("Password"),
                SizedBox(height: 3.h),
                MyTextField(
                  controller: passwordController,
                  hintText: "Enter password",
                  obscureText: true,
                  prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                ),
                SizedBox(height: 10.h),

                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ForgotPasswordPage()));
                    },
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(
                        color: Color.fromARGB(255, 155, 155, 155),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),

                // Login Button
                CustomElevatedButton(
                  label: 'Login',
                  onPressed: () async {
                    try {
                      await authNotifier.signInWithEmail(
                          emailController.text, passwordController.text);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()));
                    } catch (e) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  },
                ),

                SizedBox(height: 20.h),

                // Google Sign-In Button
                CustomElevatedButton(
                  label: 'Sign in with Google',
                  onPressed: () async {
                    try {
                      await authNotifier.signInWithGoogle();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()));
                    } catch (e) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  },
                  icon: Image.asset('lib/images/google.jpeg',
                      width: 24.w, height: 24.h),
                ),

                SizedBox(height: 20.h),

                // Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?",
                        style: TextStyle(fontSize: 14, color: Colors.grey)),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpPage()),
                        );
                      },
                      child: const Text(" Sign Up",
                          style: TextStyle(
                              color: Color.fromARGB(255, 155, 155, 155))),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build section titles
  Padding _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Text(
        title,
        style: TextStyle(
          color: const Color.fromARGB(255, 214, 214, 215),
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
