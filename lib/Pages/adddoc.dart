import 'package:docy/provider/upload.dart';
import 'package:path/path.dart'; // Required for basename function
import 'dart:io'; // Required for File
import 'package:docy/tile/addDocTile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart'; // Import file_picker
import 'package:firebase_storage/firebase_storage.dart'; // Import Firebase storage
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart'; // Import permission_handler
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddDocumentPage extends ConsumerWidget {
  const AddDocumentPage({Key? key}) : super(key: key);

  // Request storage permissions
  Future<void> requestStoragePermissions() async {
    if (await Permission.storage.request().isGranted) {
      // Permissions are granted
    } else {
      // Handle permission denied
    }
  }

  // Show progress dialog
  void _showProgressDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Uploading...'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              SizedBox(height: 20.h),
              Consumer(builder: (context, ref, child) {
                final uploadState = ref
                    .watch(uploadProvider); // Access the provider using watch
                return Text(
                  'Upload Progress: ${(uploadState.progress * 100).toStringAsFixed(2)}%',
                );
              }),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed:
                  null, // Disable the button to prevent interaction during upload
              child: const Text('Uploading...'),
            ),
          ],
        );
      },
    );
  }

  // Close the progress dialog
  void _closeProgressDialog(BuildContext context) {
    Navigator.of(context).pop(); // Close the dialog
  }

  // METHOD TO UPLOAD TO FIREBASE
  Future<void> uploadToFirebase(
      BuildContext context, String filePath, WidgetRef ref) async {
    await requestStoragePermissions(); // Request permissions before proceeding

    User? user = FirebaseAuth.instance.currentUser; // Get the current user
    if (user == null) {
      _showDialog(context, 'Error', 'User not logged in.');
      return; // If no user is logged in, exit the function
    }

    if (filePath.isEmpty) {
      _showDialog(context, 'Error', 'No file selected.');
      return;
    }

    try {
      String fileName = basename(filePath); // Get the file name from the path
      Reference storageRef = FirebaseStorage.instance.ref(
          '/users/${user.uid}/documents/$fileName'); // Create a reference to the user's folder

      // Show the progress dialog
      _showProgressDialog(context);
      ref.read(uploadProvider.notifier).startUpload();

      // Upload file
      UploadTask uploadTask = storageRef.putFile(File(filePath));

      // Listen for state changes, errors, and completion
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        ref.read(uploadProvider.notifier).updateProgress(
            snapshot.bytesTransferred.toDouble() /
                snapshot.totalBytes.toDouble());
      }, onError: (e) {
        ref.read(uploadProvider.notifier).setError();
        _closeProgressDialog(
            context); // Close the progress dialog in case of an error
      });

      await uploadTask;

      // Get the download URL
      String downloadUrl = await storageRef.getDownloadURL();

      // Save document metadata to Firestore
      await saveDocumentMetadata(fileName, downloadUrl);

      _closeProgressDialog(context); // Close the dialog after upload completes
      ref.read(uploadProvider.notifier).completeUpload();
    } catch (e) {
      ref.read(uploadProvider.notifier).setError();
      _closeProgressDialog(context); // Close the dialog in case of an error
      _showDialog(context, 'Error', e.toString()); // Show error dialog
    }
  }

  // Save document metadata to Firestore
  Future<void> saveDocumentMetadata(String fileName, String downloadUrl) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection('userDocuments').add({
      'userId': user.uid,
      'fileName': fileName,
      'downloadUrl': downloadUrl,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Helper method to show dialog
  void _showDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  // METHOD TO HANDLE A SINGLE FILE
  Future<void> uploadSingleFile(BuildContext context, WidgetRef ref) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      String filePath = result.files.single.path!;
      await uploadToFirebase(context, filePath, ref); // Start upload process
    } else {
      _showDialog(context, 'Error', 'No file selected.');
    }
  }

  // Method to handle uploading multiple files
  Future<void> uploadMultipleFiles(BuildContext context, WidgetRef ref) async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null && result.files.isNotEmpty) {
      for (var file in result.files) {
        String filePath = file.path!;
        await uploadToFirebase(
            context, filePath, ref); // Start upload for each file
      }
    } else {
      _showDialog(context, 'Error', 'No files selected.');
    }
  }

// Method to handle uploading multiple files or entire folders
  Future<void> uploadFilesOrFolder(BuildContext context, WidgetRef ref) async {
    // Enable picking multiple files
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
      withData: false, // Ensures we get the path without file data in memory
    );

    if (result != null && result.files.isNotEmpty) {
      for (var file in result.files) {
        String? filePath = file.path;
        if (filePath != null) {
          await uploadToFirebase(context, filePath, ref); // Upload each file
        }
      }
    } else {
      _showDialog(context, 'Error', 'No files or folders selected.');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Documents'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0.w),
          child: Column(
            children: [
              // Use Expanded for progress indicator to prevent overflow
              Expanded(
                child: Column(
                  children: [
                    LinearProgressIndicator(
                      value: ref
                          .watch(uploadProvider)
                          .progress, // Handle null safely
                    ),
                    SizedBox(height: 20.h),
                    Expanded(
                      child: ListView(
                        children: [
                          SizedBox(height: 20.h),
                          DocTile(
                            name: "Add File",
                            icon: const Icon(Icons.add),
                            onTap: () async {
                              await uploadSingleFile(
                                  context, ref); // Start single file upload
                            },
                          ),
                          SizedBox(height: 16.h),
                          DocTile(
                            name: "Add Multiple Files",
                            icon: const Icon(Icons.library_add_outlined),
                            onTap: () async {
                              await uploadMultipleFiles(
                                  context, ref); // Start multiple files upload
                            },
                          ),
                          SizedBox(height: 16.h), // Space between tiles
                          DocTile(
                            name: "Add Folder",
                            icon: const Icon(Icons.library_add_check_sharp),
                            onTap: () async {
                              await uploadMultipleFiles(
                                  context, ref); // Start multiple files upload
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Assuming you have a valid uploadProvider
