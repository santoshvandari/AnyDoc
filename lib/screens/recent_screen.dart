import 'package:anydoc/filehandler/csv_handler.dart';
import 'package:anydoc/filehandler/excel_hander.dart';
import 'package:anydoc/filehandler/pdf_handler.dart';
import 'package:anydoc/filehandler/txt_handler.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';

class RecentScreen extends StatefulWidget {
  const RecentScreen({super.key});

  @override
  _RecentScreenState createState() => _RecentScreenState();
}

class _RecentScreenState extends State<RecentScreen> {
  List<Map<String, dynamic>> recentDocuments = [];

  @override
  void initState() {
    super.initState();
    _loadRecentDocuments();
  }

  Future<void> _loadRecentDocuments() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? recentFiles = prefs.getStringList('recent_files');

      if (recentFiles != null) {
        setState(() {
          recentDocuments = recentFiles
              .map((file) => json.decode(file) as Map<String, dynamic>)
              .toList();
          recentDocuments.sort((a, b) {
            return DateTime.parse(b['date'])
                .compareTo(DateTime.parse(a['date']));
          });
        });
      }
    } catch (e) {
      debugPrint("Error loading recent documents: $e");
    }
  }

  Future<void> _removeDocument(int index) async {
    try {
      recentDocuments.removeAt(index);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> updatedFiles =
          recentDocuments.map((doc) => json.encode(doc)).toList();
      await prefs.setStringList('recent_files', updatedFiles);
      setState(() {});
    } catch (e) {
      debugPrint("Error removing document: $e");
    }
  }

  Future<void> _updateRecentDocument(Map<String, dynamic> document) async {
    try {
      // Update the date when the document is opened again
      document['date'] = DateTime.now().toIso8601String();

      // Remove the old entry and insert it at the top
      recentDocuments
          .removeWhere((doc) => doc['file_path'] == document['file_path']);
      recentDocuments.insert(0, document);

      // Save the updated list to SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> updatedFiles =
          recentDocuments.map((doc) => json.encode(doc)).toList();
      await prefs.setStringList('recent_files', updatedFiles);

      setState(() {});
    } catch (e) {
      debugPrint("Error updating document: $e");
    }
  }

  void _checkFileAndOpen(String filePath, String title, String filetype) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        final document =
            recentDocuments.firstWhere((doc) => doc['file_path'] == filePath);

        // Update the recent document when it's opened
        await _updateRecentDocument(document);

        if (filetype.isNotEmpty) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => filetype == 'pdf'
                ? PDFViewer(filePath: filePath)
                : filetype == 'txt'
                    ? TXTViewer(filePath: filePath)
                    : filetype == 'csv'
                        ? CSVViewer(filePath: filePath)
                        : filetype == 'excel'
                            ? ExcelViewer(filePath: filePath)
                            : PDFViewer(filePath: filePath),
          ));
        }
      } else {
        debugPrint(
            'File not found: $filePath. Removing from recent documents.');
        _removeDocument(
            recentDocuments.indexWhere((doc) => doc['file_path'] == filePath));
      }
    } catch (e) {
      debugPrint("Error checking file and opening: $e");
    }
  }

  void _showOptions(BuildContext context, int index) {
    final document = recentDocuments[index];
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.open_in_new),
              title: const Text('Open'),
              onTap: () {
                Navigator.pop(context);
                _checkFileAndOpen(document['file_path'], document['title'],
                    document['filetype']);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Remove'),
              onTap: () {
                Navigator.pop(context);
                _removeDocument(index);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recently Opened Documents',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF53826E),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: recentDocuments.isEmpty
                  ? const Center(
                      child: Text(
                        'No recent files.',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: recentDocuments.length,
                      itemBuilder: (context, index) {
                        final document = recentDocuments[index];
                        final filetype = document['filetype'] as String;
                        IconData icondata = filetype == "pdf"
                            ? (Icons.picture_as_pdf)
                            : filetype == "txt"
                                ? (Icons.text_snippet)
                                : filetype == "csv"
                                    ? (Icons.table_chart_outlined)
                                    : filetype == "excel"
                                        ? (Icons.table_chart_outlined)
                                        : (Icons.insert_drive_file);
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: Icon(
                              icondata,
                              color: const Color(0xFF3E699C),
                            ),
                            title: Text(
                              document['title'] as String,
                              style: const TextStyle(fontSize: 18),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            subtitle: Text(
                              'Opened on ${DateTime.parse(document['date']).toLocal().toString().split(' ')[0]}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.more_vert),
                              onPressed: () {
                                _showOptions(context, index);
                              },
                            ),
                            onTap: () {
                              _checkFileAndOpen(document['file_path'],
                                  document['title'], document['filetype']);
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
