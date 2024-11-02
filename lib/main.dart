import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

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

    // Check the file type
    if (file.extension == 'pdf') {
      // Open the PDF file
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PDFScreen(filePath: file.path!),
      ));
    } else {
      // Handle other file types as necessary
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unsupported file type.')),
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
      // body: Center(
      //   child: ElevatedButton(
      //     onPressed: () {
      //       _pickFile(context);
      //     },
      //     child: const Text(
      //       'Pick and Open File',
      //       style: TextStyle(color: Colors.white),
      //     ),
      //     style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
      //   ),
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _pickFile(context),
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}

class PDFScreen extends StatelessWidget {
  final String filePath;

  PDFScreen({required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
        backgroundColor: Colors.green,
      ),
      body: PDFView(
        filePath: filePath,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: false,
        pageFling: false,
        onPageChanged: (int? page, int? total) {
          print('Page $page of $total');
        },
      ),
    );
  }
}
