import 'package:excel/excel.dart' as excel_lib;
import 'package:flutter/material.dart';
import 'dart:io';

class ExcelViewer extends StatefulWidget {
  final String filePath;

  const ExcelViewer({Key? key, required this.filePath}) : super(key: key);

  @override
  _ExcelViewerState createState() => _ExcelViewerState();
}

class _ExcelViewerState extends State<ExcelViewer> {
  List<List<String>> _excelData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadExcelData();
  }

  Future<void> _loadExcelData() async {
    try {
      var fileBytes = await File(widget.filePath).readAsBytes();
      var excel = excel_lib.Excel.decodeBytes(fileBytes);

      if (excel.tables.isEmpty) {
        _showUnsupportedFileTypeDialog(context);
        return;
      }

      List<List<String>> excelData = [];

      for (var table in excel.tables.keys) {
        for (var row in excel.tables[table]!.rows) {
          var rowData =
              row.map((cell) => cell?.value.toString() ?? "").toList();
          excelData.add(rowData);

          // Debug: Print each row's data
          print("Row data: $rowData");
        }
        break; // Only load the first table
      }

      setState(() {
        _excelData = excelData;
        _isLoading = false; // Data has been loaded, stop loading spinner
      });
    } catch (e) {
      print("Error loading Excel file: $e");
      setState(() {
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
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          if (_excelData.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Table(
                    border: TableBorder.all(
                      color: Colors.black,
                      width: 1,
                    ),
                    defaultColumnWidth: const IntrinsicColumnWidth(),
                    children: _excelData.map((row) {
                      return TableRow(
                        children: row.map((cell) {
                          return Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 1),
                            ),
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
            ),
          if (_excelData.isEmpty && !_isLoading)
            const Center(
              child: Text(
                "No data available or failed to load the Excel file.",
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }
}
