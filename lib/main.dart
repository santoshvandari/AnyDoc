import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  void _pickFile(BuildContext context) async {
    // Open storage to pick files
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    // If no file is picked, return
    if (result == null || result.files.isEmpty) return;

    // Get the file from the result object
    final file = result.files.first;

    // Open the file
    _openFile(context, file);
  }

  void _openFile(BuildContext context, PlatformFile file) async {
    if (file.path != null) {
      final result = await OpenFile.open(file.path);
      // Optionally show a message based on the result
      if (result.message != null && result.message!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.message!)),
        );
      }
    } else {
      // Handle the case when the file path is null
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File path is null.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AnyDoc'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.green[100],
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _pickFile(context);
          },
          child: const Text(
            'Pick and Open File',
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        ),
      ),
    );
  }
}
