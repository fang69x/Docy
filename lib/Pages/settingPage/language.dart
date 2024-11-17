import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LanguagePreferencesPage extends StatefulWidget {
  const LanguagePreferencesPage({super.key});

  @override
  State<LanguagePreferencesPage> createState() =>
      _LanguagePreferencesPageState();
}

class _LanguagePreferencesPageState extends State<LanguagePreferencesPage> {
  String selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Language Preferences'),
        backgroundColor: const Color.fromARGB(255, 137, 74, 226),
      ),
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
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Language',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20.h),
              _buildLanguageOption('English'),
              _buildLanguageOption('Spanish'),
              _buildLanguageOption('French'),
              _buildLanguageOption('German'),
              SizedBox(
                height: 100.h,
              ),
              const Center(
                child: Card(
                  margin: EdgeInsets.all(20),
                  child: Text(
                    'Feature will be available in future',
                    style: TextStyle(
                        fontSize: 20, color: Color.fromARGB(255, 27, 27, 27)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String language) {
    return Card(
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        title: Text(language, style: TextStyle(fontSize: 18.sp)),
        trailing: Radio<String>(
          value: language,
          groupValue: selectedLanguage,
          onChanged: (value) {
            setState(() {
              selectedLanguage = value!;
            });
          },
        ),
      ),
    );
  }
}
