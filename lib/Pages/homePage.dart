import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docy/Pages/scan.dart';
import 'package:docy/Pages/scan_doc.dart';
import 'package:docy/Pages/textform.dart';
import 'package:docy/Pages/upload_doc.dart';
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

  Future<void> _addFolder() async {
    final folderNameController = TextEditingController();
    final userId = FirebaseAuth.instance.currentUser?.uid;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Folder'),
          content: MyTextField(
            controller: folderNameController,
            hintText: 'Folder Name',
            obscureText: false,
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final folderName = folderNameController.text.trim();
                if (folderName.isNotEmpty && userId != null) {
                  try {
                    // Call the addFolder function
                    await _addFolder();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Folder created successfully')),
                    );
                  } catch (e) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                } else {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a folder name')),
                  );
                }
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                folderNameController.dispose();  // Dispose of the controller when the dialog is dismissed
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
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
                  SizedBox(
                    height: 50.h,
                  ),
                  Center(
                    child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0.w, vertical: 10.h),
                        child: GestureDetector(
                          onTap: () async {
                            // ignore: unused_local_variable
                            final choice = await showDialog<String>(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  elevation: 16,
                                  backgroundColor: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        const Text(
                                          'Choose Document Action',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.deepPurple,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (BuildContext
                                                    context) =>
                                                        DocumentScannerPage(),
                                                  ),
                                                );
                                              },
                                              child: const Column(
                                                children: [
                                                  Icon(
                                                    Icons.camera_alt,
                                                    size: 50,
                                                    color: Colors.deepPurple,
                                                  ),
                                                  Text('Scan'),
                                                ],
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (BuildContext
                                                    context) =>
                                                    const AddDocumentPage(),
                                                  ),
                                                );
                                              },
                                              child: const Column(
                                                children: [
                                                  Icon(
                                                    Icons.upload_file,
                                                    size: 50,
                                                    color: Colors.deepPurple,
                                                  ),
                                                  Text('Upload'),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: CircleAvatar(
                            radius: 30.r,
                            backgroundColor: Colors.deepPurple,
                            child: Icon(
                              Icons.add,
                              size: 32.sp,
                              color: Colors.white,
                            ),
                          ),
                        )),
                  ),
                  Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 8.0.h),
                        child: Text(
                          "Add Document",
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple),
                        ),
                      )),
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
                  padding: EdgeInsets.all(10.0.w),
                  child: Column(
                    children: [
                      // Create Folder Button
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.h),
                        child: ElevatedButton(
                          onPressed:
                          _addFolder, // Call your _addFolder method to create a folder
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors
                                .deepPurple, // You can customize the color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 15.h,horizontal: 10.w
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.create_new_folder,
                                  color: Colors.white),
                              SizedBox(width: 8.0.w),
                              Text(
                                'Create Folder',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Existing GridView with Document Tiles
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 16.0.w,
                        mainAxisSpacing: 16.0.h,
                        children: [
                          HomeTile(
                            name: 'Scanned Documents',
                            icon: const Icon(Icons.edit_document,
                                size: 32, color: Colors.deepPurple),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                  const ScannedDocuments(),
                                ),
                              );
                            },
                          ),
                          HomeTile(
                            name: 'Uploaded Documents',
                            icon: const Icon(Icons.camera_alt,
                                size: 32, color: Colors.deepPurple),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                  const UploadedDocuments(),
                                ),
                              );
                            },
                          ),
                        ],
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
