import 'package:flutter/material.dart';

class CommentLogPage extends StatelessWidget {
  final List<Map<String, String>> comments = [
    {
      'name': 'Priya Paradhi',
      'date': '2024-09-30',
      'comment': 'Call not done as all documents are pending'
    },
    {
      'name': 'Priti Rao',
      'date': '2024-09-28',
      'comment': 'We need to verify the payment details once more.'
    },
    {
      'name': 'Disha Dinde',
      'date': '2024-09-25',
      'comment': 'The client has requested some changes to the agreement.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comment Log"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: comments.length,
          itemBuilder: (context, index) {
            final comment = comments[index];
            return buildCommentCard(
              comment['name']!,
              comment['date']!,
              comment['comment']!,
            );
          },
        ),
      ),
    );
  }

  // Method to build each comment card
  Widget buildCommentCard(String name, String date, String comment) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              comment,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
