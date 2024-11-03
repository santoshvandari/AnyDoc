import 'package:flutter/material.dart';

class RecentScreen extends StatelessWidget {
  const RecentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for recently opened documents
    final recentDocuments = [
      {'title': 'Document 1', 'date': 'Nov 1, 2024', 'icon': Icons.description},
      {
        'title': 'Document 2',
        'date': 'Oct 30, 2024',
        'icon': Icons.insert_drive_file
      },
      {
        'title': 'Document 3',
        'date': 'Oct 28, 2024',
        'icon': Icons.picture_as_pdf
      },
    ];

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
              child: ListView.builder(
                itemCount: recentDocuments.length,
                itemBuilder: (context, index) {
                  final document = recentDocuments[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Icon(
                        document['icon'] as IconData,
                        color: const Color(0xFF3E699C),
                      ),
                      title: Text(
                        document['title'] as String,
                        style: const TextStyle(fontSize: 18),
                      ),
                      subtitle: Text(
                        'Opened on ${document['date']}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {
                          // Action for more options
                          debugPrint('More options for ${document['title']}');
                        },
                      ),
                      onTap: () {
                        // Action to open the document
                        debugPrint('Opening document: ${document['title']}');
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
