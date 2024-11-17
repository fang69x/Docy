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

// send otp ka function

  Future<bool> sendOtp(String email) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/send-otp'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Check if the message indicates success
        if (data['message'] == 'OTP sent successfully') {
          return true;
        } else {
          return false;
        }
      } else {
        print("Failed to send OTP, Status code: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error in sendOtp: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.watch(authProvider.notifier); // Auth provider

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 137, 74, 226),
              Color.fromARGB(255, 1, 10, 26)
            ], // Blue gradient to match the app's tone
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 20.w, vertical: 30.h), // Responsive padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                Center(
                  child: SizedBox(
                    height: 120.h,
                    width: 120.w,
                    child: Lottie.asset(
                      'lib/assets/lottie/Registration.json',
                      fit: BoxFit.contain,
                      repeat: true,
                    ),
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 25.sp, // Responsive font size
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  'Sign up to get started',
                  style: TextStyle(
                    fontSize: 18.sp, // Responsive font size
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 10.h),

                // Name Input
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Text(
                    "Name",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14.sp), // Responsive font size
                  ),
                ),
                SizedBox(height: 10.h),
                MyTextField(
                  controller: nameController,
                  hintText: "Enter full name",
                  obscureText: false,
                  prefixIcon: const Icon(Icons.person, color: Colors.grey),
                ),
                SizedBox(height: 10.h),

                // Email Input
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Text(
                    "Email",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14.sp), // Responsive font size
                  ),
                ),
                SizedBox(height: 10.h),
                MyTextField(
                  controller: emailController,
                  hintText: "Enter email",
                  obscureText: false,
                  prefixIcon: const Icon(Icons.email, color: Colors.grey),
                ),
                SizedBox(height: 10.h),

                // Password Input
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Text(
                    "Password",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14.sp), // Responsive font size
                  ),
                ),
                SizedBox(height: 10.h),
                MyTextField(
                  controller: passwordController,
                  hintText: "Enter password",
                  obscureText: true,
                  prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                ),
                SizedBox(height: 10.h),

                // Confirm Password Input
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Text(
                    "Confirm Password",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14.sp), // Responsive font size
                  ),
                ),
                SizedBox(height: 10.h),
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: "Re-enter password",
                  obscureText: true,
                  prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                ),
                SizedBox(height: 20.h),

                CustomElevatedButton(
                  label: 'Sign Up',
                  onPressed: () async {
                    // Send OTP without creating Firebase account
                    bool otpSent = await sendOtp(emailController.text);
                    if (otpSent) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("OTP has been sent to your email.")),
                      );
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
                        const SnackBar(content: Text("Failed to send OTP.")),
                      );
                    }
                  },
                ),
                SizedBox(height: 10.h),

                // Already have an account? Login link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?",
                        style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey)), // Responsive font size
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: const Text(
                        " Login",
                        style: TextStyle(
                            color: Color.fromARGB(255, 155, 155, 155)),
                      ),
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
}
