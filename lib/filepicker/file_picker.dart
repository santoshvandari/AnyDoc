import 'dart:io';

import 'package:anydoc/filehandler/pdf_handler.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FilePickerScreen {
  void pickFile(BuildContext context) async {
    // Open storage to pick files
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    // If no file is picked, return
    if (result == null || result.files.isEmpty) return;

    // Show the preloader while the file is being processed
    _showLoadingDialog(context);

    // Get the file from the result object
    File file = File(result.files.single.path!);

    // Check the file type
    if (file.path.endsWith('.pdf')) {
      // Hide the preloader
      Navigator.of(context).pop();

      // Open the PDF file
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PDFViewer(filePath: file.path),
      ));
    } else {
      // Hide the preloader
      Navigator.of(context).pop();

      // Show the alert dialog for unsupported file type
      showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: AlertDialog(
              title: const Text('Unsupported file type'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'OK',
                  ),
                ),
              ],
            ),
          );
        },
      );
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
}
