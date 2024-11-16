import 'package:docy/Pages/docdetail.dart';
import 'package:docy/provider/themeProvider.dart';
import 'package:docy/tile/homepagetile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:docy/Pages/searchPage.dart';
import 'package:docy/Pages/setting_page.dart';
import 'package:docy/Pages/profile.dart';
import 'package:docy/Pages/adddoc.dart';
import 'package:docy/Pages/loginPage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(bottomNavIndexProvider);

    return Scaffold(
      body: IndexedStack(
        index: currentIndex, // This will control which page is displayed
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

  // Home Page Content
  Widget _homePageContent() {
    return CustomScrollView(
      primary: true,
      slivers: <Widget>[
        SliverAppBar(
          backgroundColor: Colors.deepPurple,
          title: const Text('DOCY',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          centerTitle: true,
          expandedHeight: 200.h,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.deepPurple.shade700,
                    Colors.deepPurple.shade400,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.nightlight_round), // Dark mode icon
              onPressed: () {
                final currentThemeMode = ref.read(themeProvider);
                final newThemeMode = currentThemeMode == ThemeMode.dark
                    ? ThemeMode.light
                    : ThemeMode.dark;
                ref.read(themeProvider.notifier).state = newThemeMode;
              },
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16.0.w),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16.0.w,
              mainAxisSpacing: 16.0.h,
              children: [
                HomeTile(
                  name: 'Scan File',
                  icon: const Icon(Icons.camera, size: 32),
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
                  icon: const Icon(Icons.folder, size: 32),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const MyDocuments(),
                      ),
                    );
                  },
                ),
                HomeTile(
                  name: 'Add Documents',
                  icon: const Icon(Icons.edit_document, size: 32),
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
                  icon: const Icon(Icons.settings, size: 32),
                  onTap: () {
                    // Add settings functionality or redirect here
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
