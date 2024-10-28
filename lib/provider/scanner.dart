// scanned_documents_notifier.dart

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Enum, State, and StateNotifier classes
enum UploadStatus { idle, uploading, success, error }

class UploadState {
  final double progress;
  final UploadStatus status;

  UploadState({this.progress = 0, this.status = UploadStatus.idle});
}

class UploadNotifier extends StateNotifier<UploadState> {
  UploadNotifier() : super(UploadState());

  void startUpload() {
    state = UploadState(progress: 0, status: UploadStatus.uploading);
  }

  void updateProgress(double progress) {
    state = UploadState(progress: progress, status: UploadStatus.uploading);
  }

  void completeUpload() {
    state = UploadState(status: UploadStatus.success);
  }

  void setError() {
    state = UploadState(status: UploadStatus.error);
  }
}

final uploadProvider =
    StateNotifierProvider<UploadNotifier, UploadState>((ref) {
  return UploadNotifier();
});

class ScannedDocumentsNotifier
    extends StateNotifier<List<Map<String, dynamic>>> {
  final Ref ref;

  ScannedDocumentsNotifier(this.ref) : super([]) {
    fetchScannedDocuments();
  }

  Future<void> fetchScannedDocuments() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('scannedDocuments')
          .where('userId', isEqualTo: user.uid)
          .orderBy('timestamp', descending: true)
          .get();

      state = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error fetching scanned documents: $e');
    }
  }

  Future<void> deleteDocument(String documentId) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Delete the document from Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('documents')
            .doc(documentId)
            .delete();

        // Remove the document from the local state immediately
        state = state.where((doc) => doc['id'] != documentId).toList();
      } catch (e) {
        print('Error deleting document: $e');
      }
    }
  }

  Future<void> addDocument(File file, {bool isScanned = false}) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final uploadNotifier = ref.read(uploadProvider.notifier);
    uploadNotifier.startUpload();

    try {
      // Define storage path based on document type
      String filePath = isScanned
          ? 'users/${user.uid}/scanned_docs/${file.path.split('/').last}'
          : 'users/${user.uid}/uploaded_docs/${file.path.split('/').last}';

      final storageRef = FirebaseStorage.instance.ref().child(filePath);
      final uploadTask = storageRef.putFile(file);

      // Monitor upload progress
      uploadTask.snapshotEvents.listen((snapshot) {
        double progress =
            snapshot.bytesTransferred / snapshot.totalBytes.toDouble();
        uploadNotifier.updateProgress(progress);
      });

      // Wait for upload to complete
      await uploadTask;
      final downloadUrl = await storageRef.getDownloadURL();
      uploadNotifier.completeUpload();

      // Document metadata to save in Firestore
      Map<String, dynamic> documentData = {
        'userId': user.uid,
        'fileName': file.path.split('/').last,
        'downloadUrl': downloadUrl,
        'timestamp': Timestamp.now(),
        'isScanned': isScanned, // Optional flag to indicate document type
      };

      // Save document metadata in Firestore under user's document collection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('documents')
          .add(documentData);

      // Update local state
      state = [...state, documentData];
    } catch (e) {
      uploadNotifier.setError();
      print('Error uploading document: $e');
    }
  }
}

final scannedDocumentsProvider =
    StateNotifierProvider<ScannedDocumentsNotifier, List<Map<String, dynamic>>>(
        (ref) => ScannedDocumentsNotifier(ref));
