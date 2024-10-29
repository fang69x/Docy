import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docy/provider/scanner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_document_scanner/flutter_document_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';

class DocumentScannerPage extends ConsumerWidget {
  final DocumentScannerController _controller = DocumentScannerController();

  Future<String?> _showRenameDialog(BuildContext context) async {
    TextEditingController controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Document Name'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Document Name'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Upload'),
              onPressed: () {
                Navigator.of(context)
                    .pop(controller.text); // Return the entered name
              },
            ),
          ],
        );
      },
    );
  }

  DocumentScannerPage({super.key});

  Uint8List? _capturedImage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uploadState = ref.watch(uploadProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Scanner'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _capturedImage == null
                ? DocumentScanner(
                    controller: _controller,
                    onSave: (Uint8List imageBytes) {
                      _capturedImage = imageBytes;
                      (context as Element).markNeedsBuild();
                    },
                  )
                : Image.memory(_capturedImage!),
          ),
          if (_capturedImage != null)
            ElevatedButton(
              onPressed: () async {
                // Show dialog to get the document name
                String? documentName = await _showRenameDialog(context);
                if (documentName == null || documentName.isEmpty) {
                  // If no name was provided, show an error or return
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Please enter a valid document name.')),
                  );
                  return;
                }

                try {
                  // Start upload
                  ref.read(uploadProvider.notifier).startUpload();

                  // Get the current user
                  User? user = FirebaseAuth.instance.currentUser;
                  if (user == null) {
                    // If the user is not logged in, show an error or handle accordingly
                    print("User not logged in");
                    ref.read(uploadProvider.notifier).setError();
                    return;
                  }

                  // Define the storage path using the user ID
                  String fileName =
                      'users/${user.uid}/scanned_documents/$documentName.png';
                  final storageRef = FirebaseStorage.instance.ref(fileName);

                  // Create an upload task and upload the file
                  final uploadTask = storageRef.putData(
                    _capturedImage!,
                    SettableMetadata(contentType: 'image/png'),
                  );

                  // Monitor the upload progress
                  uploadTask.snapshotEvents.listen((snapshot) {
                    double progress = snapshot.bytesTransferred /
                        snapshot.totalBytes.toDouble();
                    ref.read(uploadProvider.notifier).updateProgress(progress);
                  });

                  // Wait for upload completion and get download URL
                  await uploadTask;
                  final downloadUrl = await storageRef.getDownloadURL();
                  ref.read(uploadProvider.notifier).completeUpload();

                  // Save metadata to Firestore under the user’s collection
                  Map<String, dynamic> documentData = {
                    'userId': user.uid,
                    'fileName': documentName,
                    'downloadUrl': downloadUrl,
                    'timestamp': Timestamp.now(),
                  };

                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid)
                      .collection('documents')
                      .add(documentData);

                  print("Document uploaded successfully");
                } catch (e) {
                  // Set error status on failure
                  ref.read(uploadProvider.notifier).setError();
                  print('Error uploading document: $e');
                }
              },
              child: const Text('Upload'),
            ),
          if (uploadState.status == UploadStatus.uploading)
            LinearProgressIndicator(value: uploadState.progress),
          if (uploadState.status == UploadStatus.success)
            const Text('Upload Successful!'),
          if (uploadState.status == UploadStatus.error)
            const Text('Upload Failed!'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _controller.takePhoto(minContourArea: 80000.0);
        },
        child: const Icon(Icons.camera),
      ),
    );
  }
}
