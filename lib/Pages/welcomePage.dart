import 'package:docy/Pages/loginPage.dart';
import 'package:docy/provider/app_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod

class Welcomepage extends ConsumerWidget {
  const Welcomepage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // You can read the app state to decide what to do or display
    ref.watch(appStateProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Image/Icon at the top
                Image.asset(
                  'lib/images/Designer (1).jpeg', // Corrected the image path
                  height: 500,
                ),
                const SizedBox(height: 40),

                // Title Text
                const Text(
                  'Upload your Document for the Future',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // Subtitle Text
                const Text(
                  'Effortlessly store and access your documents anytime, ensuring they\'re always organized and secure.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 60),

                // Get Started Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // Optionally authenticate the user here
                      ref
                          .read(appStateProvider.notifier)
                          .authenticate(); // Call authenticate
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => LoginPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFFF4B342), // Golden button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
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
    );
  }
}
