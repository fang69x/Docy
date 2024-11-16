import 'package:docy/Pages/docdetail.dart';
import 'package:docy/Pages/scan.dart';
import 'package:docy/provider/themeProvider.dart';
import 'package:docy/tile/bannercard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:docy/Pages/adddoc.dart';
import 'package:docy/Pages/profile.dart';
import 'package:docy/Pages/searchPage.dart';
import 'package:docy/Pages/setting_page.dart';
import 'package:docy/tile/homepagetile.dart';

final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String userName = "";
  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  void _fetchUserName() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userName = user.displayName ??
            'Guest'; // Fetch display name, or 'Guest' if null
      });
    }
  }

  Widget build(BuildContext context) {
    final currentIndex = ref.watch(bottomNavIndexProvider);

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: [
          _homePageContent(),
          const SearchPage(),
          const SettingPage(),
          const ProfilePage(),
        ],
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: currentIndex,
        onTap: (index) {
          ref.read(bottomNavIndexProvider.notifier).state = index;
        },
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.home),
            title: const Text('Home'),
            selectedColor: Colors.deepPurple,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.search),
            title: const Text('Search'),
            selectedColor: Colors.deepPurple,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.settings),
            title: const Text('Settings'),
            selectedColor: Colors.deepPurple,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.account_circle),
            title: const Text('Profile'),
            selectedColor: Colors.deepPurple,
          ),
        ],
      ),
    );
  }

  // Home Page Content with Full-Screen SliverAppBar
  Widget _homePageContent() {
    return CustomScrollView(
      primary: true,
      slivers: <Widget>[
        SliverAppBar(
          backgroundColor: Colors.transparent,
          expandedHeight: 500.h, // Adjust the height for the SliverAppBar
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 137, 74, 226),
                    Color.fromARGB(255, 1, 10, 26)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Greeting with User's Name and Profile Picture on the Right
                  SizedBox(
                    height: 100.h,
                  ),
                  // 2. Custom Scrollable Banner Section
                  Container(
                    height: 150.h, // Adjust the height for the banners
                    padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          // Custom Banner 1 - App Info
                          BannerCard(
                            title: 'Welcome to Docy!',
                            subtitle:
                                'Manage your documents with ease. Upload, view, and organize your files effortlessly!',
                          ),
                          SizedBox(
                              width: 16.0.w), // Add spacing between banners

                          // Custom Banner 2 - Recently Uploaded Documents
                          BannerCard(
                            title: 'Recently Uploaded Documents',
                            subtitle:
                                'Check out the latest documents you uploaded.',
                          ),
                          SizedBox(
                              width: 16.0.w), // Add spacing between banners

                          // Add more banners as needed
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          centerTitle: true,
        ),
        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0.w),
            child: Card(
              surfaceTintColor: const Color.fromARGB(255, 62, 5,
                  143), // Optional: Makes the card's surface transparent
              elevation: 20,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), // Rounded top left corner
                  topRight: Radius.circular(25), // Rounded top right corner
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft:
                      Radius.circular(25), // Ensure the top corners are clipped
                  topRight: Radius.circular(25),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.0.w),
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16.0.w,
                    mainAxisSpacing: 16.0.h,
                    children: [
                      HomeTile(
                        name: 'Scan File',
                        icon: const Icon(Icons.camera,
                            size: 32, color: Colors.deepPurple),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  DocumentScannerPage(),
                            ),
                          );
                        },
                      ),
                      HomeTile(
                        name: 'View Documents',
                        icon: const Icon(Icons.folder,
                            size: 32, color: Colors.deepPurple),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const MyDocuments(),
                            ),
                          );
                        },
                      ),
                      HomeTile(
                        name: 'Add Documents',
                        icon: const Icon(Icons.edit_document,
                            size: 32, color: Colors.deepPurple),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const AddDocumentPage(),
                            ),
                          );
                        },
                      ),
                      HomeTile(
                        name: 'Settings',
                        icon: const Icon(Icons.settings,
                            size: 32, color: Colors.deepPurple),
                        onTap: () {
                          // Add settings functionality or redirect here
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
