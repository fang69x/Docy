import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docy/Pages/adddoc.dart';
import 'package:docy/Pages/profile.dart';
import 'package:docy/Pages/scan_doc.dart';
import 'package:docy/Pages/searchPage.dart';
import 'package:docy/Pages/setting_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:docy/Pages/scan.dart';
import 'package:docy/Pages/upload_doc.dart';
import 'package:docy/tile/homepagetile.dart';
import 'package:docy/Pages/textform.dart';

final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with TickerProviderStateMixin {
  String userName = "";
  late PageController _pageController;
  late Timer _timer;
  late AnimationController _fabController;

  @override
  void initState() {
    super.initState();
    _fetchUserName();
    _pageController = PageController(viewportFraction: 0.85);
    _startAutoScroll();
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..forward();
  }

  void _fetchUserName() {
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      userName = user?.displayName ?? 'Guest';
    });
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_pageController.hasClients) {
        final nextPage = (_pageController.page?.toInt() ?? 0) + 1;
        _pageController.animateToPage(
          nextPage % 5,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutQuint,
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
                    await FirebaseFirestore.instance.collection('folders').add({
                      'name': folderName,
                      'userId': userId,
                      'createdAt': FieldValue.serverTimestamp(),
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Folder created successfully')),
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
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    _fabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: IndexedStack(
        index: ref.watch(bottomNavIndexProvider),
        children: const [
          _HomeContent(),
          SearchPage(),
          SettingPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
      floatingActionButton: ScaleTransition(
        scale: CurvedAnimation(
          parent: _fabController,
          curve: Curves.easeOutBack,
        ),
        child: FloatingActionButton(
          onPressed: _showActionDialog,
          backgroundColor: Colors.deepPurple,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return SalomonBottomBar(
      currentIndex: ref.watch(bottomNavIndexProvider),
      onTap: (index) => ref.read(bottomNavIndexProvider.notifier).state = index,
      items: [
        SalomonBottomBarItem(
          icon: const Icon(Icons.home_rounded),
          title: const Text("Home"),
          selectedColor: Colors.deepPurple,
        ),
        SalomonBottomBarItem(
          icon: const Icon(Icons.search_rounded),
          title: const Text("Search"),
          selectedColor: Colors.deepPurple,
        ),
        SalomonBottomBarItem(
          icon: const Icon(Icons.settings_rounded),
          title: const Text("Settings"),
          selectedColor: Colors.deepPurple,
        ),
        SalomonBottomBarItem(
          icon: const Icon(Icons.person_rounded),
          title: const Text("Profile"),
          selectedColor: Colors.deepPurple,
        ),
      ],
    );
  }

  void _showActionDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogButton(
              icon: Icons.camera_alt_rounded,
              label: "Scan Document",
              color: Colors.deepPurple,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DocumentScannerPage()),
              ),
            ),
            SizedBox(height: 16.h),
            _buildDialogButton(
              icon: Icons.upload_rounded,
              label: "Upload File",
              color: Colors.blueAccent,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddDocumentPage()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: () {
          Navigator.pop(context);
          onTap();
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color.withOpacity(0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            children: [
              Icon(icon, size: 40.w, color: Colors.white),
              SizedBox(height: 12.h),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          expandedHeight: 320.h,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6C5CE7), Color(0xFF1A1A2E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: kToolbarHeight * 1.5),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: const _Header(),
                  ),
                  SizedBox(height: 32.h),
                  SizedBox(
                    height: 180.h,
                    child: PageView.builder(
                      itemCount: 5,
                      itemBuilder: (context, index) => Container(
                        margin: EdgeInsets.symmetric(horizontal: 8.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          color: Colors.white.withOpacity(0.1),
                        ),
                        child: Center(
                          child: Text(
                            "Banner ${index + 1}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.all(24.w),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              ElevatedButton(
                onPressed: () => _HomePageState()._addFolder(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  padding:
                      EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.create_new_folder, color: Colors.white),
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
              SizedBox(height: 24.h),
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
                        color: Colors.deepPurple),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ScannedDocuments()),
                    ),
                  ),
                  HomeTile(
                    name: 'Uploaded Documents',
                    icon:
                        const Icon(Icons.camera_alt, color: Colors.deepPurple),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UploadedDocuments()),
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome Back,",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16.sp,
              ),
            ),
            Text(
              "User Name",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(Icons.notifications_none_rounded, color: Colors.white),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
