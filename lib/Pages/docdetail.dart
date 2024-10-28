import 'package:docy/Pages/scan_doc.dart';
import 'package:docy/Pages/upload_doc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:docy/Pages/loginPage.dart';
import 'package:docy/tile/homepagetile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final userProvider = StateProvider<User?>((ref) {
  return FirebaseAuth.instance.currentUser;
});

class MyDocuments extends ConsumerWidget {
  const MyDocuments({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<User?>(
      future: FirebaseAuth.instance.authStateChanges().first,
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData && snapshot.data != null) {
          return _buildHomePage(context, ref, snapshot.data!);
        } else {
          return LoginPage();
        }
      },
    );
  }

  Widget _buildHomePage(BuildContext context, WidgetRef ref, User user) {
    return Scaffold(
      body: CustomScrollView(
        primary: true,
        slivers: <Widget>[
          const SliverAppBar(
            title: Text('My Documents'),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(
                  16.0.w), // Use ScreenUtil for responsive padding
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  HomeTile(
                    name: 'Scanned Documents',
                    icon: const Icon(Icons.camera),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => ScannedDocuments(),
                        ),
                      );
                    },
                  ),
                  HomeTile(
                    name: 'Uploaded Documents',
                    icon: const Icon(Icons.camera),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              UploadedDocuments(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
