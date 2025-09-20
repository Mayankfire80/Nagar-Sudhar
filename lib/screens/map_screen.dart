// lib/screens/map_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:fix_my_city/models/issue_data_model.dart';
import 'package:fix_my_city/screens/notifications_screen.dart';
import 'package:fix_my_city/screens/settings_screen.dart';

class MapScreen extends StatefulWidget {
  final List<IssueData> reports;

  const MapScreen({super.key, required this.reports});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Map Widget
            FlutterMap(
              options: const MapOptions(
                initialCenter: LatLng(23.7788, 86.4382),
                initialZoom: 15.0,
                interactionOptions: InteractionOptions(
                  flags: InteractiveFlag.all,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                MarkerLayer(
                  markers: widget.reports.map<Marker>((issue) {
                    Color markerColor = Colors.red;
                    // Check the status and set the marker color
                    if (issue.currentStatus.toLowerCase() == 'in progress') {
                      markerColor = Colors.orange;
                    } else if (issue.currentStatus.toLowerCase() ==
                        'resolved') {
                      markerColor = Colors.green;
                    } else {
                      markerColor = Colors.red;
                    }
                    return Marker(
                      point: issue.location,
                      child: GestureDetector(
                        onTap: () {
                          _showIssueDetails(context, issue);
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

  void _showIssueDetails(BuildContext context, IssueData issue) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.only(bottom: 100, left: 16, right: 16),
          height: MediaQuery.of(context).size.height * 0.38,
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  Row(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: AssetImage(issue.imageUrl),
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
                              issue.title,
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
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.redAccent.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Text(
                                'New Report',
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Report Statement: ${issue.description}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Report On: ${issue.reportedOn}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Current Status: ${issue.currentStatus}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
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
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black,
                            side: const BorderSide(color: Colors.black),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: const Text('View Details'),
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
