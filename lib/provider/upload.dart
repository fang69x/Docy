import 'package:flutter_riverpod/flutter_riverpod.dart';

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

// Provider
final uploadProvider =
    StateNotifierProvider<UploadNotifier, UploadState>((ref) {
  return UploadNotifier();
});
