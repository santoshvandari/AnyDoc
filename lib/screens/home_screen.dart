import 'package:anydoc/filepicker/file_picker.dart';
import 'package:anydoc/screens/recent_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF3E699C),
          title: const Text('AnyDoc'),
          centerTitle: true,
          foregroundColor: Colors.white,
          elevation: 5,
        ),
        body: const RecentScreen(),
        floatingActionButton: Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: FloatingActionButton(
            onPressed: () {
              FilePickerScreen().pickFile(context);
            },
            backgroundColor: const Color(0xFF3E699C),
            elevation: 0,
            child: const Icon(
              Icons.add,
              size: 25,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
