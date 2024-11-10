import 'dart:io';
import 'package:anydoc/screens/home_screen.dart';
import 'package:docx_to_text/docx_to_text.dart';
import 'package:flutter/material.dart';

class DocxViewer extends StatefulWidget {
  final String filePath;

  const DocxViewer({super.key, required this.filePath});

  @override
  _DocxViewerState createState() => _DocxViewerState();
}

class _DocxViewerState extends State<DocxViewer> {
  String content = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    readFromDocxFile();
  }

  Future<void> readFromDocxFile() async {
    try {
      final file = File(widget.filePath);
      final bytes = await file.readAsBytes();
      content = docxToText(bytes);
    } catch (e) {
      _showUnsupportedFileTypeDialog(context);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                      (route) => false);
                },
                child: const Text('OK'),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AnyDoc'),
        backgroundColor: const Color(0xFF3E699C),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Container(
                  color: Colors.white,
                  width: MediaQuery.sizeOf(context).width,
                  child: Text(
                    content,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ),
      ),
    );
  }
}
