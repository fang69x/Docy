import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScannedDocumentsNotifier extends StateNotifier<List<String>> {
  ScannedDocumentsNotifier() : super([]);

  void addDocument(String documentPath) {
    state = [...state, documentPath]; // Add the new document to the list
  }

  void clearDocuments() {
    state = []; // Clear all scanned documents
  }
}

final scannedDocumentsProvider =
    StateNotifierProvider<ScannedDocumentsNotifier, List<String>>(
  (ref) => ScannedDocumentsNotifier(),
);
