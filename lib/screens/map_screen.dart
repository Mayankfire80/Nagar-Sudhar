// lib/screens/map_screen.dart (FINAL REACTIVE VERSION - ACTION SIMPLIFIED)

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:fix_my_city/models/issue_data_model.dart';
import 'package:fix_my_city/screens/notifications_screen.dart';
import 'package:fix_my_city/screens/settings_screen.dart';
import 'dart:io';
// 🔥 RIVERPOD: Import Riverpod and the reports provider
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

// THE FULL MODAL LOGIC (Called by the marker's onTap)
void _showIssueDetails(BuildContext context, IssueData issue, WidgetRef ref) {
    // UPDATED: Robust Image Provider Logic for Modal
    ImageProvider imageProvider;
    if (issue.imageUrl.startsWith('assets/')) {
      imageProvider = AssetImage(issue.imageUrl);
    } else if (issue.imageUrl.startsWith('http')) {
      imageProvider = NetworkImage(issue.imageUrl);
    } else {
      // Logic for local path (fallback)
      final File imageFile = File(issue.imageUrl);
      imageProvider = imageFile.existsSync() 
          ? FileImage(imageFile) 
          : const AssetImage('assets/pothole1.png');
    }

    // Logic to determine colors for status/severity
    Color statusColor = Colors.grey;
    if (issue.currentStatus.toLowerCase() == 'pending') {
      statusColor = Colors.redAccent;
    } else if (issue.currentStatus.toLowerCase() == 'in progress') {
      statusColor = Colors.orange;
    } else if (issue.currentStatus.toLowerCase() == 'resolved') {
      statusColor = Colors.green;
    }

    Color severityColor;
    switch (issue.severity.toLowerCase()) {
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
        // Use Consumer to react to real-time changes inside the modal
        return Consumer(builder: (context, modalRef, child) {
          // Re-read the current state of this specific report from the list
          final currentReport = modalRef.watch(reportsProvider).firstWhere(
            (r) => r.id == issue.id, 
            orElse: () => issue 
          );
          
          return Container(
            // FIX: Reduced bottom margin and used padding to ensure visibility
            margin: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            // FIX: Using ListView for vertical expansion and content definition
            child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 10.0, bottom: 20.0), // Padding inside the modal
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
                                    'Main Road, Near Bus Stop', // Dummy Location Display
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
                                // 🔥 FIX: Action simplified to just close the modal.
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
                                child: const Text('Close Details'), // 🔥 FIX: Text changed to align with simple action
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
        }); // End of Consumer
      },
    );
} // End of _showIssueDetails

// 🔥 CONVERTED to ConsumerWidget - Removed reports parameter
class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  // MapController is static for easier management
  static final MapController _mapController = MapController();

  // Helper function to get the initial center point
  LatLng _getInitialCenter(List<IssueData> reports) {
    return reports.isNotEmpty 
      ? reports.first.location 
      : const LatLng(23.7788, 86.4382); 
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 🔥 REACTIVE DATA: Watching the filtered list! 
    final List<IssueData> reports = ref.watch(filteredReportsProvider);
    
    final initialCenter = _getInitialCenter(reports);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Map Widget
            FlutterMap(
              mapController: _mapController, 
              options: MapOptions(
                initialCenter: initialCenter, 
                initialZoom: 15.0,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all,
                ),
                onTap: (tapPosition, point) {
                  // Handle tap/click events
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                MarkerLayer(
                  // Markers are now built from the reactive 'reports' list
                  markers: reports.map<Marker>((issue) {
                    Color markerColor = Colors.grey; 

                    // --- SEVERITY-BASED COLOR LOGIC ---
                    switch (issue.severity.toLowerCase()) {
                      case 'low':
                        markerColor = Colors.green;
                        break;
                      case 'medium':
                        markerColor = Colors.yellow.shade700; 
                        break;
                      case 'high':
                        markerColor = Colors.red;
                        break;
                      case 'urgent':
                        markerColor = Colors.red.shade900; 
                        break;
                      default:
                        markerColor = Colors.blueGrey;
                    }
                    return Marker(
                      point: issue.location,
                      child: GestureDetector(
                        onTap: () {
                          // Pass ref to the modal so it can access the Notifier for upvotes
                          _showIssueDetails(context, issue, ref); 
                        },
                        child: Icon(
                          Icons.location_on,
                          color: markerColor,
                          size: 40,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            // App Bar with Search
            _buildMapAppBar(context),
            
            // Floating button to recenter the map
            Positioned(
              bottom: 120, // Above the custom navigation bar
              right: 20,
              child: FloatingActionButton(
                mini: true,
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                child: const Icon(Icons.my_location),
                onPressed: () {
                  // Action: Center the map on the current initial center point
                  _mapController.move(initialCenter, 15.0);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapAppBar(BuildContext context) {
    return Positioned(
      top: 10,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CircleAvatar(
                    backgroundImage: AssetImage('assets/avatar.png'),
                    radius: 20,
                  ),
                  const Text(
                    'नगर सुधार',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Row(
                    children: [
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
              const SizedBox(height: 10),
              // Search Bar
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.black87,
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
      ),
    );
  }
}