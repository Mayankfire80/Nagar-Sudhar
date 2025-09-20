import 'package:flutter/material.dart';
import 'package:fix_my_city/models/issue_data_model.dart';
import 'dart:io';

class ReportsScreen extends StatelessWidget {
  final List<IssueData> reports;
  final Function(int) onUpvote;
  final Function(int) onDownvote;

  const ReportsScreen({
    super.key,
    required this.reports,
    required this.onUpvote,
    required this.onDownvote,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 202, 233, 217),
            Color.fromARGB(255, 171, 233, 230),
            Colors.white,
          ],
          stops: [0.0, 0.70, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text(
            'Reports Near You',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: ListView.builder(
          itemCount: reports.length,
          itemBuilder: (context, index) {
            final report = reports[index];
            return _buildReportItem(context, report, index);
          },
        ),
      ),
    );
  }

  Widget _buildReportItem(BuildContext context, IssueData report, int index) {
    Color statusColor;
    if (report.currentStatus == 'pending') {
      statusColor = Colors.red;
    } else if (report.currentStatus == 'in progress') {
      statusColor = Colors.orange;
    } else {
      statusColor = Colors.green;
    }

    // Check if the image is an asset or a file
    ImageProvider imageProvider;
    if (report.imageUrl.startsWith('assets/')) {
      imageProvider = AssetImage(report.imageUrl);
    } else {
      imageProvider = FileImage(File(report.imageUrl));
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    report.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    report.reportedOn,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      report.currentStatus.toUpperCase(),
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => onUpvote(index),
                      icon: Icon(
                        Icons.thumb_up_alt_outlined,
                        size: 20,
                        color: Colors.green,
                      ),
                    ),
                    Text(
                      '${report.upvotes}',
                      style: TextStyle(color: Colors.green),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => onDownvote(index),
                      icon: Icon(
                        Icons.thumb_down_alt_outlined,
                        size: 20,
                        color: Colors.red,
                      ),
                    ),
                    Text(
                      '${report.downvotes}',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    report.currentStatus,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}