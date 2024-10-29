import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DocumentNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  DocumentNotifier() : super([]) {
    fetchUploadedDocuments(); // Call the method when the notifier is created
  }

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
            .map((doc) => {
                  ...doc.data(),
                  'id': doc.id, // Include the document ID for deletion
                })
            .toList();
      });
    } catch (e) {
      // Optionally, you can notify the user with a Snackbar or other means.
    }
  }

  // Method to delete a document
  Future<void> deleteDocument(String documentId, String downloadUrl) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Delete the document from Firestore
        await FirebaseFirestore.instance
            .collection('uploadedDocuments') // Correct the collection name
            .doc(documentId)
            .delete();

        // Optional: Remove the document from the local state if necessary
        state = state.where((doc) => doc['id'] != documentId).toList();

        // Delete the file from Firebase Storage
        final storageRef = FirebaseStorage.instance.refFromURL(downloadUrl);
        await storageRef.delete();
        // ignore: empty_catches
      } catch (e) {}
    }
  }

  final documentProvider =
      StateNotifierProvider<DocumentNotifier, List<Map<String, dynamic>>>(
    (ref) => DocumentNotifier(),
  );
}
