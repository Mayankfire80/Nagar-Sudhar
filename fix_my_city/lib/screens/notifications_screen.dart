// lib/screens/notifications_screen.dart
import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  final List<Map<String, String>> _notifications = const [
    {
      'title': 'Report Resolved!',
      'body': 'A municipal worker has resolved the "Streetlight Not Working" issue you reported.',
      'time': '2 min ago',
    },
    {
      'title': 'New Upvote',
      'body': 'Your "Pothole" report just got a new upvote.',
      'time': '1 hour ago',
    },
    {
      'title': 'Status Update',
      'body': 'The status of your "Sewer Leakage" report is now "In Progress".',
      'time': '3 hours ago',
    },
    {
      'title': 'New Feedback',
      'body': 'Your report has received feedback from the municipal department.',
      'time': '1 day ago',
    },
    {
      'title': 'Community Shoutout',
      'body': 'You are featured on the community leaderboard!',
      'time': '1 day ago',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
              ),
              title: Text(
                notification['title']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                notification['body']!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Text(
                notification['time']!,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              onTap: () {
                // Handle notification tap
              },
            ),
          );
        },
      ),
    );
  }
}