import 'package:docy/Pages/settingPage/about.dart';
import 'package:docy/Pages/settingPage/changePassword.dart';
import 'package:docy/Pages/settingPage/editProfile.dart';
import 'package:docy/Pages/settingPage/help.dart';
import 'package:docy/Pages/settingPage/language.dart';
import 'package:docy/Pages/settingPage/notificationSettings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50.h),
                _buildSectionTitle('Account Settings'),
                SizedBox(height: 10.h),
                _buildSettingOption(
                  icon: Icons.person,
                  title: 'Edit Profile',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EditProfilePage()));
                  },
                ),
                _buildSettingOption(
                  icon: Icons.lock,
                  title: 'Change Password',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ChangePasswordPage()));
                  },
                ),
                SizedBox(height: 20.h),
                _buildSectionTitle('App Settings'),
                SizedBox(height: 10.h),
                _buildSettingOption(
                  icon: Icons.notifications,
                  title: 'Notification Settings',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const NotificationSettingsPage()));
                  },
                ),
                _buildSettingOption(
                  icon: Icons.language,
                  title: 'Language Preferences',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const LanguagePreferencesPage()));
                  },
                ),
                SizedBox(height: 20.h),
                _buildSectionTitle('Others'),
                SizedBox(height: 10.h),
                _buildSettingOption(
                  icon: Icons.help,
                  title: 'Help & Support',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HelpAndSupportPage()));
                  },
                ),
                _buildSettingOption(
                  icon: Icons.info,
                  title: 'About',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AboutPage()));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildSettingOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      margin: EdgeInsets.symmetric(vertical: 8.h),
      elevation: 5,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 137, 74, 226),
              Color.fromARGB(255, 1, 10, 26),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          leading: Icon(icon, color: Colors.white, size: 20.sp),
          title: Text(
            title,
            style: TextStyle(fontSize: 15.sp, color: Colors.white),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
