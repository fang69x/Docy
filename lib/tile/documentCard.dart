import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io'; // Import this for File

class ViewDocumentCard extends StatelessWidget {
  final String fileName;
  final String downloadUrl;
  final String fileExtension;
  final VoidCallback onDownload;

  const ViewDocumentCard({
    super.key,
    required this.fileName,
    required this.fileExtension,
    required this.onDownload,
    required this.downloadUrl,
  });

  @override
  Widget build(BuildContext context) {
    IconData fileIcon = Icons.file_present; // Default icon

    // Set the icon based on the file type
    switch (fileExtension) {
      case 'pdf':
        fileIcon = Icons.picture_as_pdf;
        break;
      case 'doc':
      case 'docx':
        fileIcon = Icons.insert_drive_file; // Word file icon
        break;
      case 'xls':
      case 'xlsx':
        fileIcon = Icons.table_chart; // Excel file icon
        break;
      case 'ppt':
      case 'pptx':
        fileIcon = Icons.slideshow; // PowerPoint file icon
        break;
      case 'jpg':
      case 'jpeg':
      case 'png':
        fileIcon = Icons.image; // Image file icon
        break;

      default:
        fileIcon = Icons.insert_drive_file; // Generic file icon
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.blue,
          child: Icon(fileIcon, size: 30, color: Colors.white),
        ),
        title: Text(
          fileName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.download),
          onPressed: () {
            onDownload(); // Call the download function when pressed
          },
        ),
        onTap: () async {
          // When tapping on the card, open the document
          await _openDocument(downloadUrl, fileName);
        },
      ),
    );
  }

  Future<void> _openDocument(String url, String fileName) async {
    var dir = await getApplicationDocumentsDirectory();
    String filePath = '${dir.path}/$fileName';

    // Check if the file exists
    if (await File(filePath).exists()) {
      // If the file exists, open it
      await OpenFile.open(filePath);
    } else {
      // If the file does not exist, download it first
      await downloadFile(url, fileName);
    }
  }

  Future<void> downloadFile(String url, String fileName) async {
    try {
      var dir = await getApplicationDocumentsDirectory();
      String filePath = '${dir.path}/$fileName';

      // Use Dio to download the file
      await Dio().download(url, filePath);
      print('File downloaded to $filePath');

      // Open the downloaded file
      await OpenFile.open(filePath);
    } catch (e) {
      print('Error downloading file: $e');
      // Optionally show an error message to the user
    }
  }
}
