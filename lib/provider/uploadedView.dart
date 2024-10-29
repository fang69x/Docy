import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Define the DocumentNotifier
class DocumentNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  DocumentNotifier() : super([]);

  // Method to fetch uploaded documents
  Future<void> fetchUploadedDocuments() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return; // No user is logged in

      // Listen for real-time updates
      FirebaseFirestore.instance
          .collection('uploadedDocuments')
          .where('userId', isEqualTo: user.uid)
          .orderBy('timestamp', descending: true)
          .snapshots()
          .listen((snapshot) {
        state = snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      });
    } catch (e) {
      print('Error fetching uploaded documents: $e');
      // Optionally, you can notify the user with a Snackbar or other means.
    }
  }

  // Method to delete a document
  Future<void> deleteDocument(String documentId) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentReference documentRef = FirebaseFirestore.instance
            .collection('uploadedDocuments')
            .doc(documentId);

        // Fetch the document
        DocumentSnapshot docSnapshot = await documentRef.get();

        if (docSnapshot.exists) {
          Map<String, dynamic>? data =
              docSnapshot.data() as Map<String, dynamic>?;

          if (data != null) {
            String? downloadUrl = data['downloadUrl'];
            if (downloadUrl != null) {
              String filePath =
                  downloadUrl.split('?')[0].split('/o/').last.split('?')[0];
              filePath = Uri.decodeFull(filePath.replaceAll('%20', ' '));

              // Delete the file from Firebase Storage
              await FirebaseStorage.instance
                  .ref('your/storage/path/$filePath')
                  .delete();
            }
            // Delete the document from Firestore
            await documentRef.delete();
            print('Document deleted: $documentId');
          }
        }
      }
    } catch (e) {
      print('Error deleting document: $e');
    }
  }
}

// Create a provider for the DocumentNotifier
final documentProvider =
    StateNotifierProvider<DocumentNotifier, List<Map<String, dynamic>>>((ref) {
  return DocumentNotifier();
});
