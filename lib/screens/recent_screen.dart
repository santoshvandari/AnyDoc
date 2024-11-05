import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class RecentScreen extends StatefulWidget {
  const RecentScreen({super.key});

  @override
  _RecentScreenState createState() => _RecentScreenState();
}

class _RecentScreenState extends State<RecentScreen> {
  List<Map<String, dynamic>> recentDocuments = [];

  @override
  void initState() {
    super.initState();
    _loadRecentDocuments();
  }

  Future<void> _loadRecentDocuments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? recentFiles = prefs.getStringList('recent_files');

    if (recentFiles != null) {
      setState(() {
        recentDocuments = recentFiles
            .map((file) => json.decode(file))
            .toList()
            .cast<Map<String, dynamic>>();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recently Opened Documents',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF53826E),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: recentDocuments.isEmpty
                  ? const Center(
                      child: Text(
                        'No recent files.',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: recentDocuments.length,
                      itemBuilder: (context, index) {
                        final document = recentDocuments[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: const Icon(
                              Icons.picture_as_pdf,
                              color: Color(0xFF3E699C),
                            ),
                            title: Text(
                              document['title'] as String,
                              style: const TextStyle(fontSize: 18),
                              overflow: TextOverflow
                                  .ellipsis, // This will add the ellipsis
                              maxLines: 1, // Limits the title to one line
                            ),
                            subtitle: Text(
                              'Opened on ${DateTime.parse(document['date']).toLocal().toString().split(' ')[0]}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.more_vert),
                              onPressed: () {
                                debugPrint(
                                    'More options for ${document['title']}');
                              },
                            ),
                            onTap: () {
                              debugPrint(
                                  'Opening document: ${document['title']}');
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
