import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:docy/provider/scanner.dart';
import 'package:docy/tile/documentCard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class ScannedDocuments extends ConsumerWidget {
  const ScannedDocuments({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the scanned documents provider
    final scannedDocuments = ref.watch(scannedDocumentsProvider);

    // Fetching uploaded documents directly from Firestore
    Future<List<Map<String, dynamic>>> _getUserDocuments() async {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null)
        return []; // Return an empty list if no user is logged in

      // Reference the user's specific document collection path
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('documents')
          .orderBy('timestamp',
              descending: true) // Optional: Order by timestamp
          .get();

      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    }

    Future<void> downloadFile(String url, String fileName) async {
      try {
        var dir = await getApplicationDocumentsDirectory();
        String filePath = '${dir.path}/$fileName';

        await Dio().download(url, filePath);
        print('File downloaded to $filePath');

        await OpenFile.open(filePath);
      } catch (e) {
        print('Error downloading file: $e');
        // Optionally show an error message to the user
      }
    }

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
            return const Center(child: Text('No documents uploaded yet.'));
          }

          final uploadedDocuments = snapshot.data!;

          return ListView.builder(
            itemCount: uploadedDocuments.length,
            itemBuilder: (context, index) {
              final document = uploadedDocuments[index];
              final fileName = document['fileName'];
              final downloadUrl = document['downloadUrl'];
              final fileExtension = fileName.split('.').last.toLowerCase();

              return ViewDocumentCard(
                fileName: fileName,
                fileExtension: fileExtension,
                downloadUrl: downloadUrl,
                onDownload: () {
                  downloadFile(
                      downloadUrl, fileName); // Call the download function
                },
              );
            },
          );
        },
      ),
    );
  }
}
