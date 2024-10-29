import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:docy/provider/uploadedView.dart';
import 'package:docy/tile/documentCard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class UploadedDocuments extends ConsumerWidget {
  const UploadedDocuments({super.key});

  Future<void> downloadFile(String url, String fileName) async {
    try {
      var dir = await getApplicationDocumentsDirectory();
      String filePath = '${dir.path}/$fileName';
      await Dio().download(url, filePath);
      await OpenFile.open(filePath);
    } catch (e) {
      // Handle download error
    }
  }

  Future<List<Map<String, dynamic>>> _getUserDocuments() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return []; // Return an empty list if no user is logged in

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('userDocuments')
        .where('userId', isEqualTo: user.uid) // Filter by userId
        .orderBy('timestamp', descending: true) // Optional: Order by timestamp
        .get();

    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uploadedDocuments = ref.watch(uploadedDocumentProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Documents'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getUserDocuments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No documents uploaded yet.'),
            );
          }

          return ListView.builder(
            itemCount: uploadedDocuments.length,
            itemBuilder: (context, index) {
              final document = uploadedDocuments[index];
              final fileName = document['fileName'];
              final downloadUrl = document['downloadUrl'];
              final fileExtension = fileName.split('.').last.toLowerCase();
              final documentId = document['id'];

              return ViewDocumentCard(
                fileName: fileName,
                fileExtension: fileExtension,
                downloadUrl: downloadUrl,
                onDownload: () => downloadFile(downloadUrl, fileName),
                onDelete: () async {
                  // Show confirmation dialog before deletion
                  final confirmDelete = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Confirm Deletion'),
                      content: const Text(
                          'Are you sure you want to delete this document?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );

                  // If confirmed, delete the document
                  if (confirmDelete == true) {
                    await ref
                        .read(uploadedDocumentProvider.notifier)
                        .deleteUploadedDocument(documentId, downloadUrl);

                    // Optionally, refresh the documents
                    await ref
                        .read(uploadedDocumentProvider.notifier)
                        .fetchUploadedDocuments();

                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Document deleted successfully.')),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
