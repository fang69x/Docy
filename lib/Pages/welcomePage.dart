import 'package:docy/Pages/loginPage.dart';
import 'package:docy/provider/app_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import ScreenUtil
class Welcomepage extends ConsumerWidget {
  const Welcomepage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(appStateProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 0, 0, 0),
              Color.fromARGB(255, 0, 0, 0)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Image/Icon at the top
                  Image.asset(
                    'lib/images/Designer (1).jpeg',
                    height: 300.h,
                    width: 300.w,
                  ),
                  SizedBox(height: 40.h), // Responsive spacing

                  // Title Text
                  Text(
                    'Upload your Document for the Future',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp, // Responsive font size
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20.h), // Responsive spacing

                  // Subtitle Text
                  Text(
                    'Effortlessly store and access your documents anytime, ensuring they\'re always organized and secure.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15.sp, // Responsive font size
                    ),
                  ),
                  SizedBox(height: 60.h), // Responsive spacing

                  // Get Started Button
                  SizedBox(
                    width: double.infinity,
                    height: 50.h, // Responsive height
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(appStateProvider.notifier).authenticate();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => LoginPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF4B342),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              25.r), // Responsive radius
                        ),
                      ),
                      child: Text(
                        'Get Started',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp, // Responsive font size
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
