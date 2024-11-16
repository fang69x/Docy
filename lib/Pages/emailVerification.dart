import 'dart:convert';

import 'package:docy/Pages/loginPage.dart';
import 'package:docy/Pages/textform.dart';
import 'package:docy/buttons/customelevated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:docy/provider/auth_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class EmailVerification extends ConsumerWidget {
  final otpController = TextEditingController();
  final String email;
  final String username;
  final String password;

  EmailVerification(this.email, this.password, this.username, {super.key});
  Future<bool> verifyOtp(String email, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp}),
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return true; // OTP verified successfully
      } else {
        return false; // OTP verification failed
      }
    } catch (e) {
      print('Error verifying OTP: $e');
      return false; // Return false in case of error
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.read(authProvider.notifier);

    return Scaffold(
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: SizedBox(
                  height: 120.h,
                  width: 120.w,
                  child: Lottie.asset(
                    'lib/assets/lottie/singing-contract.json',
                    fit: BoxFit.contain,
                    repeat: true,
                  ),
                ),
              ),
              const Text(
                "Please Enter the OTP",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                "An OTP has been sent to your email. Enter it below to verify your account.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              MyTextField(
                controller: otpController,
                hintText: "Enter OTP",
                obscureText: false,
                prefixIcon: const Icon(Icons.numbers, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: CustomElevatedButton(
                  label: "Verify OTP",
                  onPressed: () async {
                    // Use emailOtp instance and await for verification result

                    bool isOtpValid =
                        await verifyOtp(email, otpController.text);

                    if (isOtpValid) {
                      // OTP verification successful, create Firebase account
                      await authNotifier.signUp(email, password, username);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              "Account created successfully. Please log in."),
                        ),
                      );
                      // Navigate to login page after account creation
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Invalid OTP. Please try again."),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
