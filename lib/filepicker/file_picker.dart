import 'dart:io';
import 'package:anydoc/filehandler/pdf_handler.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FilePickerScreen {
  void pickFile(BuildContext context) async {
    // Show the preloader while the file is being processed
    _showLoadingDialog(context);

    // Open storage to pick files
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    // Hide the preloader as file picking is complete
    Navigator.of(context).pop();

    // If no file is picked, return
    if (result == null || result.files.isEmpty) return;

    // Get the file from the result object
    File file = File(result.files.single.path!);

    // Check the file type
    if (file.path.endsWith('.pdf')) {
      // Open the PDF file
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PDFViewer(filePath: file.path),
      ));
    } else {
      // Show the alert dialog for unsupported file type
      _showUnsupportedFileTypeDialog(context);
    }
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevents closing the dialog by tapping outside
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void _showUnsupportedFileTypeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Unsupported File Type'),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ),
          ],
        );
      },
    );
  }
}
