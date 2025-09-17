// lib/screens/reports_screen.dart
import 'package:flutter/material.dart';
import 'package:fix_my_city/models/issue_data_model.dart';
import 'package:latlong2/latlong.dart';

class ReportsScreen extends StatelessWidget {
  ReportsScreen({super.key});

  // Dummy data to simulate reported issues
  final List<IssueData> _dummyReports = [
    IssueData(
      id: '1',
      title: 'Large Pothole on Main Str.',
      description: 'Huge pothole causing traffic jam and damage to bikes.',
      imageUrl: 'assets/pothole1.png',
      location: const LatLng(23.7788, 86.4382),
      reportedOn: '12 hours ago',
      currentStatus: 'in progress',
    ),
    IssueData(
      id: '2',
      title: 'Sewer Leakage',
      description: 'Major leakage near the bus stop causing a bad smell.',
      imageUrl: 'assets/sewer_leakage.png',
      location: const LatLng(23.7795, 86.4395),
      reportedOn: '12 hours ago',
      currentStatus: 'pending',
    ),
    IssueData(
      id: '3',
      title: 'Streetlight Not Working',
      description: 'Streetlight out, making the area unsafe at night.',
      imageUrl: 'assets/streetlight.png',
      location: const LatLng(23.7770, 86.4410),
      reportedOn: '12 hours ago',
      currentStatus: 'resolved',
    ),
    IssueData(
      id: '4',
      title: 'Overflowing Trash Bins',
      description: 'Garbage bins are full and attracting stray animals.',
      imageUrl: 'assets/trash_bins.png',
      location: const LatLng(23.7760, 86.4420),
      reportedOn: '1 day ago',
      currentStatus: 'pending',
    ),
    IssueData(
      id: '5',
      title: 'Broken Water Pipe',
      description: 'Water is gushing out of a broken pipe near my house.',
      imageUrl: 'assets/water_pipe.png',
      location: const LatLng(23.7790, 86.4350),
      reportedOn: '2 days ago',
      currentStatus: 'in progress',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('My Reports', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.grey[100],
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: _dummyReports.length,
        itemBuilder: (context, index) {
          final report = _dummyReports[index];
          return _buildReportItem(report);
        },
      ),
    );
  }

  Widget _buildReportItem(IssueData report) {
    Color statusColor;
    if (report.currentStatus == 'pending') {
      statusColor = Colors.red;
    } else if (report.currentStatus == 'in progress') {
      statusColor = Colors.orange;
    } else {
      statusColor = Colors.green;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Report Image
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage(report.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 15),
            // Report Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    report.title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    report.reportedOn,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      report.currentStatus.toUpperCase(),
                      style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            // Upvote/Downvote Buttons
            Column(
              children: [
                IconButton(
                  onPressed: () {
                    // Handle upvote logic here
                  },
                  icon: const Icon(Icons.thumb_up_alt_outlined),
                  color: Colors.green,
                ),
                IconButton(
                  onPressed: () {
                    // Handle downvote logic here
                  },
                  icon: const Icon(Icons.thumb_down_alt_outlined),
                  color: Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}