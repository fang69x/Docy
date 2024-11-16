import 'package:docy/buttons/customelevated.dart';
import 'package:docy/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider); // Watch the authentication state

    return Scaffold(
      body: user == null // Check if the user is signed in
          ? const Center(
              child: Text(
                'No user signed in',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            )
          : Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 137, 74, 226),
                    Color.fromARGB(255, 1, 10, 26),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max, // Ensure full height usage
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 50.h),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 30.h),

                            // Profile Info Card
                            Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(16.0.w),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color.fromARGB(255, 137, 74, 226),
                                      Color.fromARGB(255, 1, 10, 26),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 50,
                                      backgroundImage: user.photoURL != null &&
                                              user.photoURL!.isNotEmpty
                                          ? NetworkImage(user.photoURL!)
                                          : const AssetImage(
                                                  'lib/images/default_user.png')
                                              as ImageProvider,
                                    ),
                                    SizedBox(height: 20.h),

                                    // User Name
                                    Text(
                                      user.displayName ?? 'No Name Available',
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 10.h),

                                    // User Email
                                    Text(
                                      user.email ?? 'No Email Available',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),

                                    // Phone Number

                                    SizedBox(height: 10.h),

                                    // Joined Date
                                    Text(
                                      "Joined: ${user.metadata.creationTime?.toLocal() ?? "Unknown"}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 100.h),

                            // Edit Profile Button

                            // Logout Button
                            CustomElevatedButton(
                              label: 'Logout',
                              onPressed: () async {
                                await ref.read(authProvider.notifier).signOut();
                                Navigator.pushReplacementNamed(
                                    context, '/login');
                              },
                            ),

                            SizedBox(height: 20.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
