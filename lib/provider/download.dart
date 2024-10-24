import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class DownloadState {
  final bool isDownloading;
  final String? errorMessage;

  DownloadState({this.isDownloading = false, this.errorMessage});
}

final downloadProvider =
    StateNotifierProvider<DownloadNotifier, DownloadState>((ref) {
  return DownloadNotifier();
});

class DownloadNotifier extends StateNotifier<DownloadState> {
  DownloadNotifier() : super(DownloadState());

  Future<void> downloadFile(String url, String fileName) async {
    state = DownloadState(isDownloading: true);
    try {
      var dir = await getApplicationDocumentsDirectory();
      String filePath = '${dir.path}/$fileName';

      await Dio().download(url, filePath);
      print('File downloaded to $filePath');

      state = DownloadState(isDownloading: false);
      await OpenFile.open(filePath);
    } catch (e) {
      state = DownloadState(isDownloading: false, errorMessage: e.toString());
      print('Error downloading file: $e');
    }
  }
}
