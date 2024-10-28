import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:docy/provider/auth_provider.dart';
import 'package:docy/Pages/homePage.dart';
import 'package:docy/Pages/loginPage.dart';
import 'package:docy/Pages/textform.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import ScreenUtil

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
          padding: EdgeInsets.symmetric(
              horizontal: 30.w, vertical: 60.h), // Responsive padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              Center(
                child: Icon(
                  Icons.person_add,
                  color: Color(0xFFF4B342),
                  size: 80.sp, // Responsive size
                ),
              ),
              SizedBox(height: 5.h),
              Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 32.sp, // Responsive font size
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

              // Phone Number Input
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Text(
                  "Phone Number",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14.sp), // Responsive font size
                ),
              ),
              SizedBox(height: 10.h),
              MyTextField(
                controller: phoneController,
                hintText: "Enter phone number",
                obscureText: false,
                prefixIcon: const Icon(Icons.phone, color: Colors.grey),
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
              SizedBox(height: 20.h),

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

              // Sign Up Button
              SizedBox(
                width: double.maxFinite,
                height: 50.h, // Responsive height
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
                    backgroundColor: const Color(0xFFF4B342), // Button color
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Rounded corners
                    ),
                  ),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp), // Responsive font size
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Already have an account? Login link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?",
                      style:
                          TextStyle(fontSize: 14.sp)), // Responsive font size
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: Text(
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
