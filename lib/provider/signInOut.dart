import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Authentication Provider
final authProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<User?> {
  AuthNotifier() : super(FirebaseAuth.instance.currentUser) {
    // Listen to authentication state changes
    FirebaseAuth.instance.authStateChanges().listen((user) {
      state = user;
    });
  }

  // Sign out logic
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }

  // Update display name if needed
  Future<void> updateDisplayNameIfNeeded() async {
    if (state != null && state!.displayName == null) {
      await state!.updateProfile(displayName: 'Your Name');
      await state!.reload(); // Reload user to get updated information
      state = FirebaseAuth.instance.currentUser;
    }
  }
}
