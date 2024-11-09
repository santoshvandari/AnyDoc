import 'dart:io';
import 'package:anydoc/screens/home_screen.dart';
import 'package:flutter/material.dart';

class TXTViewer extends StatefulWidget {
  final String filePath;
  const TXTViewer({super.key, required this.filePath});

  @override
  TXTViewerState createState() => TXTViewerState();
}

class TXTViewerState extends State<TXTViewer> {
  String _fileContent = "No data loaded yet.";

  @override
  void initState() {
    super.initState();
    _loadFile(); // Automatically load the file when the widget is created
  }

  // Load the file and read its content
  Future<void> _loadFile() async {
    try {
      final file = File(widget.filePath);

      if (await file.exists()) {
        String content = await file.readAsString();
        setState(() {
          _fileContent = content;
        });
      } else {
        _showUnsupportedFileTypeDialog();
      }
    } catch (e) {
      _showUnsupportedFileTypeDialog();
    }
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
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              _fileContent,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }

  void _showUnsupportedFileTypeDialog() {
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
                    (route) => false,
                  );
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
