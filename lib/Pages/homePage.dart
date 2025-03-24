import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docy/Pages/adddoc.dart';
import 'package:docy/Pages/profile.dart';
import 'package:docy/Pages/scan_doc.dart';
import 'package:docy/Pages/searchPage.dart';
import 'package:docy/Pages/setting_page.dart';
import 'package:docy/tile/bannercard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:docy/Pages/scan.dart';
import 'package:docy/Pages/upload_doc.dart';
import 'package:docy/tile/homepagetile.dart';
import 'package:docy/Pages/textform.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';

// Bottom Navigation Index Provider
final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with TickerProviderStateMixin {
  // User details
  String userName = "";
  String userEmail = "";
  String userProfilePic = "";

  // Page and animation controllers
  late PageController _pageController;
  late Timer _timer;
  late AnimationController _fabController;

  // Banner data
  final List<Map<String, dynamic>> _bannerData = [
    {
      'title': 'Effortless Document Management',
      'subtitle':
          'Organize, store, and access your documents with ease and precision.',
      'icon': Icons.storage_rounded,
    },
    {
      'title': 'Instant Document Scanning',
      'subtitle':
          'Transform physical documents into digital files with just a tap.',
      'icon': Icons.document_scanner_rounded,
    },
    {
      'title': 'Secure Cloud Storage',
      'subtitle':
          'Your documents are safely stored and accessible from anywhere.',
      'icon': Icons.cloud_done_rounded,
    },
    {
      'title': 'Smart Search Capabilities',
      'subtitle':
          'Find any document instantly with our advanced search technology.',
      'icon': Icons.search_rounded,
    },
  ];

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
    _pageController = PageController(viewportFraction: 0.85);
    _startAutoScroll();
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..forward();
  }

  // Fetch current user details
  void _fetchUserDetails() {
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      userName = user?.displayName ?? 'Guest';
      userEmail = user?.email ?? '';
      userProfilePic = user?.photoURL ?? '';
    });
  }

  // Auto-scroll for banner
  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_pageController.hasClients) {
        final nextPage = (_pageController.page?.toInt() ?? 0) + 1;
        _pageController.animateToPage(
          nextPage % _bannerData.length,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutQuint,
        );
      }
    });
  }

  // Create new folder dialog
  Future<void> _addFolder() async {
    final folderNameController = TextEditingController();
    final userId = FirebaseAuth.instance.currentUser?.uid;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Create New Folder',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
            fontSize: 20.sp,
          ),
        ),
        content: MyTextField(
          controller: folderNameController,
          hintText: 'Folder Name',
          obscureText: false,
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
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
                    SnackBar(
                      content:
                          Text('Folder "$folderName" created successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a folder name'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  // Cleanup timers and controllers
  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    _fabController.dispose();
    super.dispose();
  }

  // Build method for the home page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: IndexedStack(
        index: ref.watch(bottomNavIndexProvider),
        children: [
          _HomeContent(
            userName: userName,
            userEmail: userEmail,
            userProfilePic: userProfilePic,
            onAddFolder: _addFolder,
            bannerData: _bannerData,
          ),
          const SearchPage(),
          const SettingPage(),
          const ProfilePage(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
      floatingActionButton: FadeInUp(
        child: ScaleTransition(
          scale: CurvedAnimation(
            parent: _fabController,
            curve: Curves.easeOutBack,
          ),
          child: FloatingActionButton(
            onPressed: _showActionDialog,
            backgroundColor: Colors.deepPurple,
            elevation: 10,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ),
    );
  }

  // Bottom navigation bar
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

  // Action dialog for adding documents
  void _showActionDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose Action',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  icon: Icons.document_scanner,
                  label: 'Scan',
                  color: Colors.deepPurple,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DocumentScannerPage()),
                  ),
                ),
                _buildActionButton(
                  icon: Icons.upload_file,
                  label: 'Upload',
                  color: Colors.blueAccent,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddDocumentPage()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Action button builder
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: CircleBorder(),
            padding: EdgeInsets.all(20.w),
            elevation: 5,
          ),
          child: Icon(icon, color: Colors.white, size: 30.w),
        ),
        SizedBox(height: 10.h),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
      ],
    );
  }
}

// Home Content Widget
class _HomeContent extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String userProfilePic;
  final VoidCallback onAddFolder;
  final List<Map<String, dynamic>> bannerData;

  const _HomeContent({
    required this.userName,
    required this.userEmail,
    required this.userProfilePic,
    required this.onAddFolder,
    required this.bannerData,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          expandedHeight: 380.h,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
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
                    child: _Header(
                      userName: userName,
                      userEmail: userEmail,
                      userProfilePic: userProfilePic,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  SizedBox(
                    height: 180.h,
                    child: PageView.builder(
                      controller: PageController(viewportFraction: 0.85),
                      itemCount: bannerData.length,
                      itemBuilder: (context, index) {
                        final banner = bannerData[index];
                        return BannerCard(
                          title: banner['title'],
                          subtitle: banner['subtitle'],
                        );
                      },
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
                onPressed: onAddFolder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  padding:
                      EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.create_new_folder,
                        color: Colors.white, size: 28.w),
                    SizedBox(width: 12.w),
                    Text(
                      'Create New Folder',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp,
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
                    icon: const Icon(Icons.document_scanner_rounded,
                        color: Colors.deepPurple),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ScannedDocuments()),
                    ),
                  ),
                  HomeTile(
                    name: 'Uploaded Documents',
                    icon: const Icon(Icons.cloud_upload_rounded,
                        color: Colors.blueAccent),
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

// Header Widget
class _Header extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String userProfilePic;

  const _Header({
    required this.userName,
    required this.userEmail,
    required this.userProfilePic,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
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
                userName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            // TODO: Implement profile or notification actions
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 25.r,
              backgroundColor: Colors.transparent,
              backgroundImage: userProfilePic.isNotEmpty
                  ? CachedNetworkImageProvider(userProfilePic)
                  : null,
              child: userProfilePic.isEmpty
                  ? Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 30.w,
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
