import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Settings',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Account Settings'),
              const SizedBox(height: 10),
              _buildSettingOption(
                icon: Icons.person,
                title: 'Edit Profile',
                onTap: () {
                  // Navigate to profile editing page
                },
              ),
              _buildSettingOption(
                icon: Icons.lock,
                title: 'Change Password',
                onTap: () {
                  // Navigate to change password page
                },
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('App Settings'),
              const SizedBox(height: 10),
              _buildSettingOption(
                icon: Icons.notifications,
                title: 'Notification Settings',
                onTap: () {
                  // Navigate to notification settings page
                },
              ),
              _buildSettingOption(
                icon: Icons.language,
                title: 'Language Preferences',
                onTap: () {
                  // Navigate to language settings page
                },
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('Others'),
              const SizedBox(height: 10),
              _buildSettingOption(
                icon: Icons.help,
                title: 'Help & Support',
                onTap: () {
                  // Navigate to help & support page
                },
              ),
              _buildSettingOption(
                icon: Icons.info,
                title: 'About',
                onTap: () {
                  // Navigate to about page
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.deepPurple.shade700,
      ),
    );
  }

  Widget _buildSettingOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        leading: Icon(icon, color: Colors.deepPurple, size: 28),
        title: Text(title, style: const TextStyle(fontSize: 18)),
        onTap: onTap,
      ),
    );
  }
}
