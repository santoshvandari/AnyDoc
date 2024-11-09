// import 'package:flutter/material.dart';
// import 'package:flutter_pptx/flutter_pptx.dart';
// import 'dart:io';

// class PPTViewer extends StatefulWidget {
//   final String filePath;
//   const PPTViewer({super.key, required this.filePath});

//   @override
//   _PPTViewerState createState() => _PPTViewerState();
// }

// class _PPTViewerState extends State<PPTViewer> {
//   List<Widget> slides = [];

//   @override
//   void initState() {
//     super.initState();
//     loadPptFile();
//   }

//   Future<void> loadPptFile() async {
//     String documentPath = await getDocumentPath();

//     // Load the PPTX file
//     List<Widget> loadedSlides = await FlutterPptxViewer.load(widget.filePath);
//     setState(() {
//       slides = loadedSlides;
//     });
//   }

//   Future<String> getDocumentPath() async {
//     Directory directory = await getApplicationDocumentsDirectory();
//     return directory.path;
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (slides.isEmpty) {
//       return Scaffold(
//         appBar: AppBar(
//           title: Text('Flutter PPT Viewer'),
//         ),
//         body: Center(
//           child: CircularProgressIndicator(),
//         ),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Flutter PPT Viewer'),
//       ),
//       body: ListView(
//         children: slides,
//       ),
//     );
//   }
// }
