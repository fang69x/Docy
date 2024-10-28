import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DocumentState {
  final List<String> documents;
  final bool isLoading;
  final String? error;

  DocumentState(
      {this.documents = const [], this.isLoading = false, this.error});
}

class DocumentNotifier extends StateNotifier<DocumentState> {
  DocumentNotifier() : super(DocumentState());

  Future<void> loadDocuments() async {
    state = DocumentState(isLoading: true);
    try {
      final documents = await fetchUploadedDocuments();
      state = DocumentState(documents: documents);
    } catch (e) {
      state = DocumentState(error: 'Failed to load documents');
    }
  }
}

// Provider
final documentProvider =
    StateNotifierProvider<DocumentNotifier, DocumentState>((ref) {
  return DocumentNotifier();
});
Future<List<String>> fetchUploadedDocuments() async {
  List<String> documentUrls = [];
  try {
    final storageRef = FirebaseStorage.instance.ref().child('uploads');

    final result = await storageRef.listAll();

    for (final item in result.items) {
      final url = await item.getDownloadURL();
      documentUrls.add(url);
    }
  } catch (e) {
    print('Error fetching documents: $e');
  }

  return documentUrls;
}
