import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:docy/tile/documentCard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class UploadedDocuments extends ConsumerWidget {
  const UploadedDocuments({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // The future for getting user documents
    Future<List<Map<String, dynamic>>> _getUserDocuments() async {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null)
        return []; // Return an empty list if no user is logged in

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('userDocuments')
          .where('userId', isEqualTo: user.uid) // Filter by userId
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

        await OpenFile.open(filePath);
      } catch (e) {
        // Optionally show an error message to the user
      }
    }

    Future<void> deleteDocument(String documentId) async {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Reference to the Firestore document
        DocumentReference documentRef = FirebaseFirestore.instance
            .collection('userDocuments') // Adjust this path as necessary
            .doc(documentId);

        // Fetch the document
        DocumentSnapshot docSnapshot = await documentRef.get();

        if (docSnapshot.exists) {
          // Explicitly cast the document data to Map<String, dynamic>
          Map<String, dynamic>? data =
              docSnapshot.data() as Map<String, dynamic>?;

          if (data != null) {
            // Check for the 'downloadUrl' or any other field that holds the file reference
            String? downloadUrl = data['downloadUrl'];

            // Ensure the downloadUrl is valid
            if (downloadUrl != null) {
              try {
                // Extract the file name from the download URL
                String filePath =
                    downloadUrl.split('?')[0].split('/o/').last.split('?')[0];
                filePath = Uri.decodeFull(filePath.replaceAll('%20', ' '));

                // Delete the file from Firebase Storage
                await FirebaseStorage.instance
                    .ref('your/storage/path/$filePath')
                    .delete(); // Adjust this as needed
                print('File deleted from Storage: $filePath');
              } catch (e) {
                print('Error deleting file from Storage: $e');
              }
            } else {
              print('No download URL found in document: $documentId');
            }

            // Delete the document from Firestore
            await documentRef.delete();
            print('Document deleted: $documentId');
          } else {
            print('Document data is null: $documentId');
          }
        } else {
          print('Document does not exist: $documentId');
        }
      } else {
        print('No user is currently signed in.');
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
            return const Center(
                child: Text('No documents uploaded yet.')); // Updated message
          }

          final documents = snapshot.data!;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final document = documents[index];
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
                onDelete: () {
                  deleteDocument(document as String);
                },
              );
            },
          );
        },
      ),
    );
  }
}
