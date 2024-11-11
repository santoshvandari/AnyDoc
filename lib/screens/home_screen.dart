import 'dart:async';
import 'package:anydoc/filepicker/file_picker.dart';
import 'package:anydoc/screens/recent_screen.dart';
import 'package:flutter/material.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late StreamSubscription _intentSub;
  final List<SharedMediaFile> _sharedFiles = [];

  @override
  void initState() {
    super.initState();

    // For sharing files coming from outside the app while the app is in the memory
    _intentSub = ReceiveSharingIntent.instance.getMediaStream().listen(
        (List<SharedMediaFile> value) {
      setState(() {
        _sharedFiles.clear();
        _sharedFiles.addAll(value);
        _processSharedFiles();
      });
    }, onError: (err) {
      debugPrint("getIntentDataStream error: $err");
    });

    // For sharing files coming from outside the app while the app is closed
    ReceiveSharingIntent.instance
        .getInitialMedia()
        .then((List<SharedMediaFile> value) {
      setState(() {
        _sharedFiles.clear();
        _sharedFiles.addAll(value);
        _processSharedFiles();
      });
    });
  }

  void _processSharedFiles() {
    if (_sharedFiles.isEmpty) return;

    for (SharedMediaFile file in _sharedFiles) {
      debugPrint('Shared file path: ${file.path}');
      debugPrint('Shared file type: ${file.type}');
      FilePickerScreen().openFile(context, file.path);
    }

    // Reset the sharing intent after processing
    ReceiveSharingIntent.instance.reset();
  }

  @override
  void dispose() {
    _intentSub.cancel();
    super.dispose();
  }

  void _openSharedFile(String filePath) {
    // Attempt to open the shared file
    try {
      FilePickerScreen().openFile(context, filePath);
    } catch (e) {
      debugPrint("Failed to open file: $e");
    }
  }

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
