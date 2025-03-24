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
                        horizontal: screenWidth * 0.08,
                        vertical: 5.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              padding: EdgeInsets.all(15.w),
                              height: constraints.maxHeight * 0.25,
                              child: Lottie.asset(
                                'lib/assets/lottie/Logging In.json',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            'Welcome Back!',
                            style: TextStyle(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Please log in to your account',
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: Colors.white70,
                            ),
                          ),
                          SizedBox(height: 10.h),

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
                          SizedBox(height: 12.h),

                          // Forgot Password
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgotPasswordPage(),
                                ),
                              ),
                              child: Text(
                                'Forgot password?',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Fixed Bottom Section with Buttons
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.08,
                    vertical: 20.h,
                  ),
                  child: Column(
                    children: [
                      CustomElevatedButton(
                        label: 'Login',
                        onPressed: () async {
                          try {
                            await authNotifier.signInWithEmail(
                              emailController.text,
                              passwordController.text,
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomePage(),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
                        },
                      ),
                      SizedBox(height: 15.h),
                      CustomElevatedButton(
                        label: 'Continue with Google',
                        onPressed: () async {
                          try {
                            await authNotifier.signInWithGoogle();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomePage(),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
                        },
                        icon: Image.asset(
                          'lib/images/google.jpeg',
                          width: 24.w,
                          height: 24.h,
                        ),
                      ),
                      SizedBox(height: 15.h),
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpPage(),
                          ),
                        ),
                        child: RichText(
                          text: TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14.sp,
                            ),
                            children: const [
                              TextSpan(
                                text: 'Sign Up',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
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

  // Section Title Helper
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white70,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
