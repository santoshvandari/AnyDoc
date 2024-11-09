import 'dart:convert';
import 'dart:io';
import 'package:anydoc/screens/home_screen.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';

class CSVViewer extends StatefulWidget {
  final String filePath;

  const CSVViewer({super.key, required this.filePath});

  @override
  _CSVViewerState createState() => _CSVViewerState();
}

class _CSVViewerState extends State<CSVViewer> {
  List<List<dynamic>> _csvData = [];
  bool _isLoading = true;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    readCSV();
  }

  Future<void> readCSV() async {
    try {
      File file = File(widget.filePath);
      final input = await file.openRead();
      List<List<dynamic>> rowsAsListOfValues = await input
          .transform(utf8.decoder)
          .transform(CsvToListConverter())
          .toList();

      setState(() {
        _csvData = rowsAsListOfValues;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isError = true;
        _isLoading = false;
      });
      _showUnsupportedFileTypeDialog(context);
    }
  }

  void _showUnsupportedFileTypeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text(
              'Failed to load CSV file. Please check the file format or path.'),
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _isError
              ? const Center(child: Text('Failed to load data'))
              : _csvData.isEmpty
                  ? const Center(child: Text('No data loaded'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: _csvData.length,
                      itemBuilder: (context, index) {
                        final row = _csvData[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              row.join(', '),
                              style: TextStyle(
                                fontWeight: index == 0
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
