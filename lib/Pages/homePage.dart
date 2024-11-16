import 'dart:async';

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
  late PageController _pageController;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _fetchUserName();
    _pageController = PageController();
    _startAutoScroll();
  }

  // Fetch user's name from FirebaseAuth
  void _fetchUserName() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userName = user.displayName ?? 'Guest';
      });
    }
  }

  // Start auto-scrolling after 5 seconds interval
  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_pageController.hasClients) {
        int nextPage = (_pageController.page?.toInt() ?? 0) + 1;
        if (nextPage >= 5) nextPage = 0; // Loop back to the first banner
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Stop the timer when the widget is disposed
    _pageController.dispose();
    super.dispose();
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
          expandedHeight: 450.h,
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
                  SizedBox(
                    height: 100.h,
                  ),
                  // Custom Scrollable Banner Section
                  Container(
                    height: 150.h, // Adjust the height for the banners
                    padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                    child: PageView(
                      controller: _pageController,
                      scrollDirection: Axis.horizontal,
                      children: [
                        BannerCard(
                          title: 'Welcome to Docy!',
                          subtitle:
                              'Manage your documents with ease. Upload, view, and organize your files effortlessly!',
                        ),
                        BannerCard(
                          title: 'Recently Uploaded Documents',
                          subtitle:
                              'Check out the latest documents you uploaded.',
                        ),
                        BannerCard(
                          title: 'New Features',
                          subtitle:
                              'We’ve added exciting new features! Explore now.',
                        ),
                        BannerCard(
                          title: 'Docy Premium',
                          subtitle:
                              'Upgrade to Docy Premium for additional benefits.',
                        ),
                        BannerCard(
                          title: 'Support',
                          subtitle:
                              'Need help? Visit our support page for assistance.',
                        ),
                      ],
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
              surfaceTintColor: const Color.fromARGB(255, 62, 5, 143),
              elevation: 20,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
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
                        name: 'Upload Documents',
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
                        name: 'Edit Documents',
                        icon: const Icon(Icons.edit,
                            size: 32, color: Colors.deepPurple),
                        onTap: () {},
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
