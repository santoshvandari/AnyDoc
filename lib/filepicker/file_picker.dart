import 'dart:convert';
import 'dart:io';
import 'package:anydoc/filehandler/doc_handler.dart';
import 'package:anydoc/filehandler/pdf_handler.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FilePickerScreen {
  void pickFile(BuildContext context) async {
    _showLoadingDialog(context);

    FilePickerResult? result = await FilePicker.platform.pickFiles();

    Navigator.of(context).pop();

    if (result == null || result.files.isEmpty) return;

    File file = File(result.files.single.path!);

    // Save the recently opened file information

    if (file.path.endsWith('.pdf')) {
      _saveRecentFile(file);
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PDFViewer(filePath: file.path),
      ));
    } else {
      _showUnsupportedFileTypeDialog(context);
    }
  }

  Future<void> _saveRecentFile(File file) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> recentFiles = prefs.getStringList('recent_files') ?? [];

    // Add the new file to the recent files list
    recentFiles.add(json.encode({
      'title': file.uri.pathSegments.last,
      'date': DateTime.now().toIso8601String(),
      'icon': 'pdf',
    }));

    // Limit the number of recent files to the last 10
    if (recentFiles.length > 10) {
      recentFiles.removeAt(0);
    }

    await prefs.setStringList('recent_files', recentFiles);
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
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
