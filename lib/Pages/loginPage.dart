import 'package:docy/Pages/forgotPassword.dart';
import 'package:docy/Pages/textform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:docy/Pages/homePage.dart';
import 'package:docy/Pages/signUp.dart';
import 'package:docy/provider/auth_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginPage extends ConsumerWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.watch(authProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 60.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Icon(
                  Icons.login,
                  color: const Color(0xFFF4B342),
                  size: 60.sp,
                ),
              ),
              SizedBox(height: 30.h),
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
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 40.h),

              // Email Input
              _buildSectionTitle("Email"),
              MyTextField(
                controller: emailController,
                hintText: "Enter email",
                obscureText: false,
                prefixIcon: const Icon(Icons.email, color: Colors.grey),
              ),
              SizedBox(height: 20.h),

              // Password Input
              _buildSectionTitle("Password"),
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
                            builder: (context) => const ForgotPasswordPage()));
                  },
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(
                      color: Color(0xFFF4B342),
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30.h),

              // Login Button
              _buildElevatedButton(
                onPressed: () async {
                  try {
                    await authNotifier.signInWithEmail(
                      emailController.text,
                      passwordController.text,
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                },
                label: 'Login',
              ),
              SizedBox(height: 20.h),

              // Google Sign-In Button
              _buildGoogleButton(authNotifier, context),

              SizedBox(height: 20.h),

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
                        MaterialPageRoute(builder: (context) => SignUpPage()),
                      );
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

  // Helper method to build section titles
  Padding _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Text(
        title,
        style: TextStyle(color: Colors.grey, fontSize: 14.sp),
      ),
    );
  }

  // Helper method to build elevated button for login
  SizedBox _buildElevatedButton(
      {required VoidCallback onPressed, required String label}) {
    return SizedBox(
      width: double.infinity,
      height: 45.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF4B342), // Button color
        ),
        child:
            Text(label, style: TextStyle(color: Colors.white, fontSize: 20.sp)),
      ),
    );
  }

  // Helper method to build Google Sign-In button
  SizedBox _buildGoogleButton(AuthNotifier authNotifier, BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 47.h,
      child: ElevatedButton.icon(
        onPressed: () async {
          try {
            await authNotifier.signInWithGoogle();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.toString())),
            );
          }
        },
        icon: Image.asset(
          'lib/images/google.jpeg', // Adjust path if necessary
          width: 24.w,
          height: 24.h,
        ),
        label: Text(
          'Sign in with Google',
          style: TextStyle(color: Colors.white, fontSize: 16.sp),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF4B342),
        ),
      ),
    );
  }
}
