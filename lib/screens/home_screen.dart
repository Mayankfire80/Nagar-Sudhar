// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
// 🔥 RIVERPOD: Import Riverpod
import 'package:flutter_riverpod/flutter_riverpod.dart'; 
import 'package:fix_my_city/screens/notifications_screen.dart';
import 'package:fix_my_city/screens/settings_screen.dart';
import 'package:fix_my_city/screens/new_report_screen.dart';
import 'package:fix_my_city/models/issue_data_model.dart';
import 'dart:io';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fix_my_city/providers/reports_provider.dart';

// --- MODAL HELPER FUNCTIONS (COPIED FOR CLICKABLE REPORT ITEMS) ---

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

// THE FULL MODAL LOGIC (COPIED AND SIMPLIFIED)
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
  
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Consumer(builder: (context, modalRef, child) {
        final currentReport = modalRef.watch(reportsProvider).firstWhere(
            (r) => r.id == report.id, 
            orElse: () => report // Fallback to initial report if somehow removed
        );

        return Container(
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
                                currentReport.title,
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
                    
                    // Assignment Status
                    if (currentReport.assignedTo != null)
                        _buildDetailChip('Assigned To', currentReport.assignedTo!, Icons.engineering, Colors.blue),
                    
                    const SizedBox(height: 15),
                    
                    // Key Metadata Chips
                    Wrap(
                      spacing: 12.0,
                      runSpacing: 8.0,
                      children: [
                        _buildDetailChip('Category', currentReport.category, Icons.category, Colors.blueGrey),
                        _buildDetailChip('Reported On', currentReport.reportedOn, Icons.access_time, Colors.teal),
                        _buildDetailChip('Severity', currentReport.severity.toUpperCase(), Icons.warning_amber, severityColor),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    // Status and Votes
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // RichText for Description
                        Expanded(
                          child: RichText(
                            maxLines: 2, 
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                              children: <TextSpan>[
                                const TextSpan(text: 'Description: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(text: currentReport.description),
                              ],
                            ),
                          ),
                        ),
                        
                        // Votes Count
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
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            }, 
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.black,
                              side: const BorderSide(color: Colors.black),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                            child: const Text('Close Details'), // 🔥 FIX: Changed button text to Close Details
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
// --- END OF MODAL HELPER FUNCTIONS ---


// 🔥 RIVERPOD: Change to ConsumerWidget
class HomeScreen extends ConsumerWidget { 
  final List<IssueData> reports;
  final VoidCallback onViewAllTapped;

  const HomeScreen({
    super.key,
    required this.reports,
    required this.onViewAllTapped,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppBar(context),
                _buildLocationSearchBar(),
                _buildYourImpactCard(context, ref), 
                _buildLatestReportsNearYou(ref), // Pass ref here
                const SizedBox(height: 120),
              ],
            ),
          ),
        ),
      ),
    );
  }

  
  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/avatar.png',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'नगर सुधार',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: SvgPicture.asset(
                  'assets/icons/language-translate.svg',
                  colorFilter: const ColorFilter.mode(
                    Colors.black87,
                    BlendMode.srcIn,
                  ),
                  height: 24,
                  width: 24,
                ),
                onPressed: () {
                  // Add your language-translate logic here
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.notifications_none,
                  color: Colors.black87,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const NotificationsScreen(),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.settings_outlined,
                  color: Colors.black87,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                // Handle location change
              },
              child: Row(
                children: [
                  Text(
                    'Katras More, Dhanbad',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.green[300],
                    ),
                  ),
                  Icon(Icons.arrow_drop_down, color: Colors.grey[500]),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey[400]),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search "issue types"',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  Icon(Icons.mic_none, color: Colors.grey[400]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildYourImpactCard(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'your impact !',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'level 5 :',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const Text(
                        'Urban Pioneer',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        '1250 points',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        '15 reports',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded( 
                  child: GestureDetector( 
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const NewReportScreen(),
                        ),
                      );
                    },
                    child: Container(
                      height: 150, 
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: Colors.white, size: 40),
                          Text(
                            'REPORT',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '+ NEW PROBLEM',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
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

  // 🔥 UPDATED: Added WidgetRef ref to pass to _buildReportItem
  Widget _buildLatestReportsNearYou(WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Latest Reports Near You',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: onViewAllTapped,
                child: const Text(
                  'View All',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Only show the first 3 reports on the home screen
          ...List.generate(
            reports.length > 3 ? 3 : reports.length,
            (index) => _buildReportItem(reports[index], ref), // Pass ref here
          ),
        ],
      ),
    );
  }

  // 🔥 UPDATED: Added WidgetRef ref to signature and made item clickable
  Widget _buildReportItem(IssueData report, WidgetRef ref) {
    Color statusColor;
    if (report.currentStatus == 'pending') {
      statusColor = Colors.red;
    } else if (report.currentStatus == 'in progress') {
      statusColor = Colors.orange;
    } else {
      statusColor = Colors.green;
    }

    // Determine if the image is an asset, a local file, or a network URL
    ImageProvider imageProvider;
    if (report.imageUrl.startsWith('assets/')) {
      // 1. Local Asset (for initial mock data) - This will now load your original images
      imageProvider = AssetImage(report.imageUrl); 
    } else if (report.imageUrl.startsWith('/data/') || report.imageUrl.startsWith('/storage/')) {
      // 2. Local File (Path from image_picker, only valid locally)
      final File imageFile = File(report.imageUrl);
      imageProvider = imageFile.existsSync() 
          ? FileImage(imageFile) 
          : const AssetImage('assets/pothole1.png'); // Fallback
    } else {
      // 3. Network URL (Cloud path from mock repository)
      imageProvider = NetworkImage(report.imageUrl);
    }

    // Wrap in Consumer to access Riverpod ref for upvote/downvote
    return Consumer(
      builder: (context, consumerRef, child) {
        final reportsNotifier = consumerRef.read(reportsProvider.notifier);

        return GestureDetector(
          // 🔥 FIX: Added GestureDetector to make it clickable
          onTap: () => _showReportDetailsModal(context, report, ref), 
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            elevation: 0,
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
                            onPressed: () => reportsNotifier.upvoteReport(report.id), // 🔥 Use report.id
                            icon: const Icon(
                              Icons.thumb_up_alt_outlined,
                              size: 20,
                              color: Colors.green, // Fixed color
                            ),
                          ),
                          Text(
                            '${report.upvotes}',
                            style: const TextStyle(color: Colors.green),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () => reportsNotifier.downvoteReport(report.id), // 🔥 Use report.id
                            icon: const Icon(
                              Icons.thumb_down_alt_outlined,
                              size: 20,
                              color: Colors.red, // Fixed color
                            ),
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
          ),
        );
      },
    );
  }
}