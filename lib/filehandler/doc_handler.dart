// import 'package:document_viewer/document_viewer.dart';
// import 'package:flutter/material.dart';

// class DocxViewer extends StatefulWidget {
//   final String filePath;

//   const DocxViewer({Key? key, required this.filePath}) : super(key: key);

//   @override
//   _DocxViewerState createState() => _DocxViewerState();
// }

// class _DocxViewerState extends State<DocxViewer> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('DOCX Viewer'),
//         backgroundColor: const Color(0xFF3E699C),
//         foregroundColor: Colors.white,
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(
//             16.0), // Add padding around the document viewer
//         child: Stack(
//           children: [
//             widget.filePath.isEmpty
//                 ? const Center(child: CircularProgressIndicator())
//                 : DocumentViewer(
//                     filePath: widget.filePath,
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
// }
