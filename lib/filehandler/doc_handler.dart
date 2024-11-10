import 'dart:io';
import 'package:docx_to_text/docx_to_text.dart';
import 'package:flutter/material.dart';

class DocxViewer extends StatefulWidget {
  final String filePath;

  const DocxViewer({super.key, required this.filePath});

  @override
  _DocxViewerState createState() => _DocxViewerState();
}

class _DocxViewerState extends State<DocxViewer> {
  @override
  void initState() {
    readFromDocxFile();
    super.initState();
  }

  String content = "";
  Future<String> readFromDocxFile() async {
    final file = File(widget.filePath);
    final bytes = await file.readAsBytes();
    content = docxToText(bytes);
    setState(() {});
    return content; // docx to text
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DOCX Viewer'),
        backgroundColor: const Color(0xFF3E699C),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Container(
              color: Colors.white,
              width: MediaQuery.sizeOf(context).width,
              child: SingleChildScrollView(
                child: Text(
                  content,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
