import 'package:docy/Pages/homePage.dart';
import 'package:docy/Pages/signUp.dart';
import 'package:docy/Pages/welcomePage.dart';
import 'package:docy/firebase_options.dart';
import 'package:docy/provider/auth_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'Pages/loginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: Docy()));
}

class Docy extends ConsumerWidget {
  const Docy({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user =
        ref.watch(authProvider); // Watch the auth provider for user state

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 240, 194, 11),
        ),
      ),
      // Check if user is logged in and navigate accordingly
      home: user != null
          ? const HomePage()
          : const Welcomepage(), // Navigate based on user state
      routes: {
        '/login': (context) =>
            LoginPage(), // Ensure LoginPage is properly referenced
        '/signup': (context) =>
            SignUpPage(), // Ensure SignUpPage is properly referenced
        '/home': (context) => const HomePage(),
      },
    );
  }
}
