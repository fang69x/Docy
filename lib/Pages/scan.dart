import 'package:docy/provider/upload.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_document_scanner/flutter_document_scanner.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';

class DocumentScannerPage extends ConsumerWidget {
  final DocumentScannerController _controller = DocumentScannerController();

  DocumentScannerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uploadState = ref.watch(uploadProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Scanner'),
      ),
      body: Column(
        children: [
          Expanded(
            child: DocumentScanner(
              controller: _controller,
              onSave: (Uint8List imageBytes) async {
                // Start upload
                ref.read(uploadProvider.notifier).startUpload();
                try {
                  // Upload to Firebase Storage
                  String fileName =
                      'scanned_documents/${DateTime.now().millisecondsSinceEpoch}.png';
                  await FirebaseStorage.instance
                      .ref(fileName)
                      .putData(
                        imageBytes,
                        SettableMetadata(contentType: 'image/png'),
                      )
                      .whenComplete(() {
                    // Notify that upload is complete
                    ref.read(uploadProvider.notifier).completeUpload();
                  });
                } catch (e) {
                  // Notify about the error
                  ref.read(uploadProvider.notifier).setError();
                }
              },
            ),
          ),
          if (uploadState.status == UploadStatus.uploading)
            LinearProgressIndicator(value: uploadState.progress),
          if (uploadState.status == UploadStatus.success)
            const Text('Upload Successful!'),
          if (uploadState.status == UploadStatus.error)
            const Text('Upload Failed!'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _controller.takePhoto(minContourArea: 80000.0);
        },
        child: const Icon(Icons.camera),
      ),
    );
  }
}
