// lib/screens/reports_screen.dart (FINAL - Button Text Corrected)
import 'package:flutter/material.dart';
import 'package:fix_my_city/models/issue_data_model.dart';
import 'dart:io';
// 🔥 RIVERPOD: Import Riverpod and the provider
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fix_my_city/providers/reports_provider.dart';

// --- MODAL HELPER FUNCTIONS (DEFINED OUTSIDE CLASS) ---

// Helper method to build a styled status badge
Widget _buildStatusBadge(String status, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(5),
      border: Border.all(color: color, width: 1),
    ),
    child: Text(
      status,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    ),
  );
}

// Helper method to build detailed info chips
Widget _buildDetailChip(String label, String value, IconData icon, Color color) {
  return Chip(
    avatar: Icon(icon, size: 16, color: color),
    label: RichText(
      text: TextSpan(
        style: TextStyle(color: Colors.grey[700], fontSize: 14),
        children: [
          TextSpan(text: '$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: value),
        ],
      ),
    ),
    backgroundColor: color.withOpacity(0.1),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
  );
}

// THE FULL MODAL LOGIC WITH ALL DETAILS - Defined as a standalone function
void _showReportDetailsModal(BuildContext context, IssueData report, WidgetRef ref) {
  // 🔥 UPDATED: Robust Image Provider Logic for Modal
  ImageProvider imageProvider;
  if (report.imageUrl.startsWith('assets/')) {
    imageProvider = AssetImage(report.imageUrl);
  } else if (report.imageUrl.startsWith('http')) {
    imageProvider = NetworkImage(report.imageUrl);
  } else {
    final File imageFile = File(report.imageUrl);
    imageProvider = imageFile.existsSync() 
        ? FileImage(imageFile) 
        : const AssetImage('assets/pothole1.png');
  }

  // Logic to determine colors for status/severity
  Color statusColor = Colors.grey;
  if (report.currentStatus.toLowerCase() == 'pending') {
    statusColor = Colors.redAccent;
  } else if (report.currentStatus.toLowerCase() == 'in progress') {
    statusColor = Colors.orange;
  } else if (report.currentStatus.toLowerCase() == 'resolved') {
    statusColor = Colors.green;
  }

  Color severityColor;
  switch (report.severity.toLowerCase()) {
    case 'urgent':
      severityColor = Colors.red.shade900;
      break;
    case 'high':
      severityColor = Colors.red;
      break;
    case 'medium':
      severityColor = Colors.yellow.shade800;
      break;
    default:
      severityColor = Colors.green;
  }

  final reportsNotifier = ref.read(reportsProvider.notifier);
  
  // 🚫 REMOVED: assignWorker function is no longer needed

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      // Use Consumer to react to real-time changes inside the modal
      return Consumer(builder: (context, modalRef, child) {
        // Re-read the current state of this specific report from the list
        final currentReport = modalRef.watch(reportsProvider).firstWhere(
            (r) => r.id == report.id, 
            orElse: () => report // Fallback to initial report if somehow removed
        );

        return Container(
          // Floating Card styling
          margin: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 2,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 10.0, bottom: 20.0), 
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. HEADER (Image and Title)
                    Row(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
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
                                currentReport.title, // Use currentReport
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Main Road, Near Bus Stop',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 5),
                              _buildStatusBadge(currentReport.currentStatus.toUpperCase(), statusColor),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    
                    // Assignment Status (NEW) - Visible to Public User
                    if (currentReport.assignedTo != null)
                      _buildDetailChip('Assigned To', currentReport.assignedTo!, Icons.engineering, Colors.blue)
                    else if (currentReport.currentStatus.toLowerCase() == 'pending')
                       _buildDetailChip('Prioritized', currentReport.severity.toUpperCase(), Icons.priority_high, currentReport.severity.toLowerCase() == 'urgent' ? Colors.red : Colors.orange),
                    const Divider(height: 30),

                    // RichText for Description (Omitted for brevity)
                    RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                        children: <TextSpan>[
                          const TextSpan(text: 'Description: ', style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: currentReport.description),
                        ],
                      ),
                    ),
                    const Divider(height: 30),

                    // Key Metadata Chips (Omitted for brevity)
                    Wrap(
                      spacing: 12.0,
                      runSpacing: 8.0,
                      children: [
                        _buildDetailChip('Category', currentReport.category, Icons.category, Colors.blueGrey),
                        _buildDetailChip('Reported On', currentReport.reportedOn, Icons.access_time, Colors.teal),
                        _buildDetailChip('Severity', currentReport.severity.toUpperCase(), Icons.warning_amber, severityColor),
                      ],
                    ),
                    const Divider(height: 30),

                    // Status and Votes
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatusBadge(currentReport.currentStatus.toUpperCase(), statusColor),
                        
                        Row(
                          children: [
                            const Icon(Icons.thumb_up, color: Colors.green, size: 20),
                            const SizedBox(width: 4),
                            Text('${currentReport.upvotes}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                            const SizedBox(width: 12),
                            const Icon(Icons.thumb_down, color: Colors.red, size: 20),
                            const SizedBox(width: 4),
                            Text('${currentReport.downvotes}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Action Buttons 
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              reportsNotifier.upvoteReport(currentReport.id);
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Upvoting...')),);
                            },
                            icon: const Icon(Icons.thumb_up_alt),
                            label: const Text('Upvote Issue'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.green,
                              side: const BorderSide(color: Colors.green),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Close Details'), // 🔥 FIX 1: Text changed to "Close Details"
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black87,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      });
    },
  );
}

// 🔥 RIVERPOD: ConsumerWidget
class ReportsScreen extends ConsumerWidget {
  final List<IssueData> reports;

  const ReportsScreen({
    super.key,
    required this.reports,
  });

  static const double _bottomPadding = 120.0;
  
  // 🔥 NEW: List of filter labels
  final List<String> _filterLabels = const [
    'All',
    'Pending',
    'In Progress',
    'Urgent',
    'Resolved',
    'Assigned', // Maps to the logic in filteredReportsProvider
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) { 
    // 🔥 NEW: Watch the filter state and the filtered list
    final selectedFilter = ref.watch(reportsFilterProvider);
    final filteredReports = ref.watch(filteredReportsProvider);

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
        body: Column(
          children: [
            // 🔥 NEW: Filter Bar
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: _filterLabels.length,
                itemBuilder: (context, index) {
                  final label = _filterLabels[index];
                  final isSelected = label == selectedFilter;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(label),
                      selected: isSelected,
                      selectedColor: Colors.redAccent.withOpacity(0.2),
                      backgroundColor: Colors.white,
                      onSelected: (selected) {
                        if (selected) {
                          // Update the filter state using ref.read
                          ref.read(reportsFilterProvider.notifier).state = label;
                        }
                      },
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.redAccent : Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected ? Colors.redAccent : Colors.grey.shade300,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            
            Expanded(
              child: ListView.builder(
                // 🔥 FIX: Added padding to ensure last reports are visible above the navbar
                padding: const EdgeInsets.only(top: 8.0, bottom: _bottomPadding), 
                itemCount: filteredReports.length, // Use filtered list
                itemBuilder: (context, index) {
                  final report = filteredReports[index];
                  return _buildReportItem(context, report, ref); // Pass ref to item
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 UPDATED: Robust Image Provider Logic
  Widget _buildReportItem(BuildContext context, IssueData report, WidgetRef ref) {
    Color statusColor;
    if (report.currentStatus.toLowerCase() == 'pending') {
      statusColor = Colors.red;
    } else if (report.currentStatus.toLowerCase() == 'in progress') {
      statusColor = Colors.orange;
    } else {
      statusColor = Colors.green;
    }

    // Determine if the image is an asset, a local file, or a network URL
    ImageProvider imageProvider;
    if (report.imageUrl.startsWith('assets/')) {
      imageProvider = AssetImage(report.imageUrl);
    } else if (report.imageUrl.startsWith('http')) {
      imageProvider = NetworkImage(report.imageUrl);
    } else {
      final File imageFile = File(report.imageUrl);
      imageProvider = imageFile.existsSync() 
          ? FileImage(imageFile) 
          : const AssetImage('assets/pothole1.png');
    }

    // 🔥 RIVERPOD: Get Notifier for button actions
    final reportsNotifier = ref.read(reportsProvider.notifier);

    return GestureDetector( // <--- GESTURE DETECTOR TO OPEN MODAL
      onTap: () => _showReportDetailsModal(context, report, ref), // Pass ref to modal
      child: Card(
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
                    image: imageProvider, // 🔥 Use the updated ImageProvider
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
                      '${report.reportedOn} ${report.assignedTo != null ? '• Assigned' : ''}', // Display assigned status
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
                        onPressed: () => reportsNotifier.upvoteReport(report.id), // 🔥 Use report.id
                        icon: const Icon(Icons.thumb_up_alt_outlined),
                        color: Colors.green,
                      ),
                      Text(
                        '${report.upvotes}',
                        style: const TextStyle(color: Colors.green),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () => reportsNotifier.downvoteReport(report.id), // 🔥 Use report.id
                        icon: const Icon(Icons.thumb_down_alt_outlined),
                        color: Colors.red,
                      ),
                      Text(
                        '${report.downvotes}',
                        style: const TextStyle(color: Colors.red),
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
                      report.severity.toUpperCase(), // Showing severity here
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
      ),
    );
  }
}