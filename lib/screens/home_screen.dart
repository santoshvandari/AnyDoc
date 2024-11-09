import 'package:anydoc/filepicker/file_picker.dart';
import 'package:anydoc/screens/recent_screen.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Method to check and request permission
  Future<void> _checkAndPickFile(BuildContext context) async {
    // Only for the final release of the app
    // PermissionStatus permissionStatus = await Permission.storage.request();
    // if (permissionStatus.isGranted) {
    //   FilePickerScreen().pickFile(context);
    // } else if (permissionStatus.isDenied) {
    //   _showPermissionDeniedDialog(context);
    // } else if (permissionStatus.isPermanentlyDenied) {
    //   _showPermissionPermanentlyDeniedDialog(context);
    // }

    // For testing purposes
    FilePickerScreen().pickFile(context);
  }

  // Dialog to show when permission is denied
  void _showPermissionDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Permission Denied'),
          content: const Text('We need access to your storage to read files.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _checkAndPickFile(context);
              },
              child: const Text('Try Again'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Dialog to show when permission is permanently denied
  void _showPermissionPermanentlyDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Permission Permanently Denied'),
          content: const Text(
              'Please enable storage permission from app settings to read files.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings(); // Open app settings
              },
              child: const Text('Go to Settings'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
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
              _checkAndPickFile(
                  context); // Check permission before picking file
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
