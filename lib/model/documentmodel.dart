import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Document {
  final String id; // Document ID from Firestore
  final String fileName;
  final String downloadUrl;

  Document({
    required this.id,
    required this.fileName,
    required this.downloadUrl,
  });
}

// FUNCTION TO FETCH DOCUMENT FROM FIRESTORE
Future<List<Document>> fetchDocuments() async {
  try {
    User? user = FirebaseAuth.instance.currentUser; // Get the current user
    if (user == null) return []; // Return empty if no user

    final snapshot = await FirebaseFirestore.instance
        .collection('userDocuments')
        .where('userId', isEqualTo: user.uid) // Filter by user ID
        .get();

    return snapshot.docs.map((doc) {
      return Document(
        id: doc.id, // Firestore document ID
        fileName: doc.data()['fileName'] ?? 'Untitled', // Default value
        downloadUrl: doc.data()['downloadUrl'] ?? '', // Default value
      );
    }).toList();
  } catch (e) {
    print("Error fetching documents: $e");
    return []; // Return empty on error
  }
}
