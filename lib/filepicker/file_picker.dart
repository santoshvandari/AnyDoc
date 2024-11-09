import 'dart:convert';
import 'dart:io';
// import 'package:anydoc/filehandler/doc_handler.dart';
import 'package:anydoc/filehandler/csv_handler.dart';
// import 'package:anydoc/filehandler/doc_handler.dart';
import 'package:anydoc/filehandler/excel_hander.dart';
import 'package:anydoc/filehandler/pdf_handler.dart';
// import 'package:anydoc/filehandler/ppt_handler.dart';
import 'package:anydoc/filehandler/txt_handler.dart';
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
    // Icons.table_chart_outlined

    if (file.path.endsWith('.pdf')) {
      _saveRecentFile(file, "pdf");
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PDFViewer(filePath: file.path),
      ));
    } else if (file.path.endsWith(".docx") || file.path.endsWith(".doc")) {
      // _saveRecentFile(file, "doc");
      // Navigator.of(context).push(MaterialPageRoute(
      //   builder: (context) => DocxViewerScreen(file.path),
      // ));
    } else if (file.path.endsWith(".xlsx") || file.path.endsWith(".xls")) {
      _saveRecentFile(file, "excel");
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ExcelViewer(filePath: file.path),
      ));
    } else if (file.path.endsWith("pptx") || file.path.endsWith("ppt")) {
      // _saveRecentFile(file, "ppt");
      // Navigator.of(context).push(MaterialPageRoute(
      //     // builder: (context) => PPTViewer(filePath: file.path),

      //     ));
    } else if (file.path.endsWith("csv")) {
      _saveRecentFile(file, "txt");
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CSVViewer(filePath: file.path),
      ));
    } else if (file.path.endsWith("txt")) {
      _saveRecentFile(file, "txt");
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => TXTViewer(filePath: file.path),
      ));
    } else {
      _showUnsupportedFileTypeDialog(context);
    }
  }

  Future<void> _saveRecentFile(File file, String icondata) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> recentFiles = prefs.getStringList('recent_files') ?? [];

    // Decode the recent files list from JSON
    List<Map<String, dynamic>> recentDocuments = recentFiles
        .map((file) => json.decode(file) as Map<String, dynamic>)
        .toList();

    // Check if the file already exists in the recent files list
    final existingIndex =
        recentDocuments.indexWhere((doc) => doc['file_path'] == file.path);

    if (existingIndex != -1) {
      // If file exists, remove it from its current position
      recentDocuments.removeAt(existingIndex);
    }

    // Add the new/updated file to the top of the list with the current date
    recentDocuments.insert(0, {
      'title': file.uri.pathSegments.last,
      'date': DateTime.now().toIso8601String(),
      'icon': icondata,
      'file_path': file.path,
    });

    // Limit the list to the last 10 items
    if (recentDocuments.length > 10) {
      recentDocuments = recentDocuments.sublist(0, 10);
    }

    // Save the updated recent files list back to SharedPreferences
    List<String> updatedFiles =
        recentDocuments.map((doc) => json.encode(doc)).toList();
    await prefs.setStringList('recent_files', updatedFiles);
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
