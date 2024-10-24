import 'package:docy/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider); // Watch the authentication state

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.orange,
      ),
      body: user == null // Check if the user is signed in
          ? Center(child: Text('No user signed in')) // Handle no user
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Display User's Avatar
                  CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        user.photoURL != null && user.photoURL!.isNotEmpty
                            ? NetworkImage(user.photoURL!)
                            : const AssetImage('lib/images/default_user.png')
                                as ImageProvider,
                  ),
                  const SizedBox(height: 20),

                  // Display User's Name
                  Text(
                    user.displayName ?? 'No Name Available',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Display User's Email
                  Text(
                    user.email ?? 'No Email Available',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFFF4B342), // Customize button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onPressed: () async {
                        await ref
                            .read(authProvider.notifier)
                            .signOut(); // Call signOut from provider
                        Navigator.pushReplacementNamed(context,
                            '/login'); // Redirect to login after logout
                      },
                      child: const Text(
                        'Logout',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
