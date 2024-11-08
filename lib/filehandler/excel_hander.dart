import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class ExcelViewer extends StatefulWidget {
  final String filePath;

  const ExcelViewer({Key? key, required this.filePath}) : super(key: key);

  @override
  _ExcelViewerState createState() => _ExcelViewerState();
}

class _ExcelViewerState extends State<ExcelViewer> {
  List<List<String>>? _excelData;
  bool _isLoading = true; // Initial loading state

  @override
  void initState() {
    super.initState();
    _loadExcelData();
  }

  Future<void> _loadExcelData() async {
    try {
      var fileBytes = await File(widget.filePath).readAsBytes();
      var excel = Excel.decodeBytes(fileBytes);

      List<List<String>> excelData = [];

      // Extract data from the first table only for simplicity
      for (var table in excel.tables.keys) {
        for (var row in excel.tables[table]!.rows) {
          var rowData =
              row.map((cell) => cell?.value.toString() ?? "").toList();
          excelData.add(rowData);
        }
        break; // Only load the first table
      }

      setState(() {
        _excelData = excelData;
        _isLoading = false; // Data has been loaded, stop loading spinner
      });
    } catch (e) {
      debugPrint("Error loading Excel file: $e");
      _showUnsupportedFileTypeDialog(context);
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
                  Navigator.of(context).pop(); // Close dialog
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
      body: Stack(
        children: [
          if (_excelData != null) // Display Excel data if available
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Table(
                  border: TableBorder.all(
                    color: Colors.black, // Border color for cells
                    width: 1, // Border width
                    borderRadius: BorderRadius.circular(2),
                  ),
                  children: _excelData!.map((row) {
                    return TableRow(
                      children: row.map((cell) {
                        return Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            cell,
                            style: const TextStyle(fontSize: 16),
                          ),
                        );
                      }).toList(),
                    );
                  }).toList(),
                ),
              ),
            ),
          if (_isLoading) // Show loading spinner while loading
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
