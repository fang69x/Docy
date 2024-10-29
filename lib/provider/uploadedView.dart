import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DocumentNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  DocumentNotifier() : super([]) {
    fetchUploadedDocuments();
  }

  Future<void> fetchUploadedDocuments() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // Listen for real-time updates from the userDocuments collection
      FirebaseFirestore.instance
          .collection('userDocuments')
          .where('userId', isEqualTo: user.uid) // Filter by user ID
          .orderBy('timestamp', descending: true)
          .snapshots()
          .listen((snapshot) {
        state = snapshot.docs
            .map((doc) => {
                  ...doc.data(),
                  'id': doc.id // Include document ID
                })
            .toList();
      });
    } catch (e) {
      print('Error fetching uploaded documents: $e');
    }
  }

  Future<void> deleteUploadedDocument(
      String documentId, String downloadUrl) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('userDocuments') // Correct collection
            .doc(documentId)
            .delete();

        state = state.where((doc) => doc['id'] != documentId).toList();

        final storageRef = FirebaseStorage.instance.refFromURL(downloadUrl);
        await storageRef.delete();
      } catch (e) {
        print('Error deleting document: $e');
      }
    }
  }
}

// Define the provider outside the class
final uploadedDocumentProvider =
    StateNotifierProvider<DocumentNotifier, List<Map<String, dynamic>>>(
  (ref) => DocumentNotifier(),
);
//finally