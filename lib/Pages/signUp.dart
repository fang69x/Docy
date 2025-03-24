import 'dart:convert';
import 'package:docy/Pages/emailVerification.dart';
import 'package:docy/buttons/CustomElevated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:docy/provider/auth_provider.dart';
import 'package:docy/Pages/homePage.dart';
import 'package:docy/Pages/loginPage.dart';
import 'package:docy/Pages/textform.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class SignUpPage extends ConsumerWidget {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  SignUpPage({super.key});

  Future<bool> sendOtp(String email) async {
    try {
      final response = await http.post(
        Uri.parse('https://docy.onrender.com/send-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );
      return response.statusCode == 200 &&
          jsonDecode(response.body)['message'] == 'OTP sent successfully';
    } catch (e) {
      print("Error in sendOtp: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.watch(authProvider.notifier);

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
            stops: [0.3, 0.7],
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 30.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              padding: EdgeInsets.all(15.w),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 5,
                                    blurRadius: 20,
                                    offset: const Offset(0, 5),
                                  )
                                ],
                              ),
                              child: Lottie.asset(
                                'lib/assets/lottie/Registration.json',
                                width: 150.w,
                                height: 150.h,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Text(
                            'Create Account',
                            style: TextStyle(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.8,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Sign up to get started',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white70,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          SizedBox(height: 40.h),

                          // Name Input
                          _buildSectionTitle("Name"),
                          SizedBox(height: 8.h),
                          MyTextField(
                            controller: nameController,
                            hintText: "Enter full name",
                            obscureText: false,
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.white70,
                              size: 20.w,
                            ),
                          ),
                          SizedBox(height: 20.h),

                          // Email Input
                          _buildSectionTitle("Email"),
                          SizedBox(height: 8.h),
                          MyTextField(
                            controller: emailController,
                            hintText: "Enter email",
                            obscureText: false,
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.white70,
                              size: 20.w,
                            ),
                          ),
                          SizedBox(height: 20.h),

                          // Password Input
                          _buildSectionTitle("Password"),
                          SizedBox(height: 8.h),
                          MyTextField(
                            controller: passwordController,
                            hintText: "Enter password",
                            obscureText: true,
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.white70,
                              size: 20.w,
                            ),
                          ),
                          SizedBox(height: 20.h),

                          // Confirm Password Input
                          _buildSectionTitle("Confirm Password"),
                          SizedBox(height: 8.h),
                          MyTextField(
                            controller: confirmPasswordController,
                            hintText: "Re-enter password",
                            obscureText: true,
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.white70,
                              size: 20.w,
                            ),
                          ),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ),
                ),

                // Fixed Bottom Section
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 20.h,
                  ),
                  child: Column(
                    children: [
                      CustomElevatedButton(
                        label: 'Sign Up',
                        onPressed: () async {
                          if (passwordController.text !=
                              confirmPasswordController.text) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Passwords do not match")),
                            );
                            return;
                          }

                          bool otpSent = await sendOtp(emailController.text);
                          if (otpSent) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EmailVerification(
                                  emailController.text,
                                  passwordController.text,
                                  nameController.text,
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Failed to send OTP")),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor:
                              const Color.fromARGB(255, 137, 74, 226),
                        ),
                      ),
                      SizedBox(height: 15.h),
                      TextButton(
                        onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        ),
                        child: RichText(
                          text: TextSpan(
                            text: "Already have an account? ",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14.sp,
                            ),
                            children: [
                              TextSpan(
                                text: 'Login',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white70,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}
