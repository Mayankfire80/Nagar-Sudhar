// lib/screens/map_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:fix_my_city/models/issue_data_model.dart';
import 'package:fix_my_city/screens/notifications_screen.dart';
import 'package:fix_my_city/screens/settings_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // Dummy data to simulate API response
  final List<IssueData> _dummyIssues = [
    IssueData(
      id: '1',
      title: 'Pot Hole',
      description:
          'Huge pothole causing traffic jam and damage to bikes. Needs urgent repair.',
      imageUrl: 'assets/pothole_detail.png',
      location: const LatLng(23.7788, 86.4382),
      reportedOn: '26/07/2025, 09:30 am',
      currentStatus: 'Pending',
    ),
    IssueData(
      id: '2',
      title: 'Sewer Leakage',
      description: 'Major leakage near the bus stop causing a bad smell.',
      imageUrl: 'assets/sewer_leakage.png',
      location: const LatLng(23.7795, 86.4395),
      reportedOn: '26/07/2025, 10:00 am',
      currentStatus: 'In Progress',
    ),
    IssueData(
      id: '3',
      title: 'Streetlight Not Working',
      description: 'Streetlight out, making the area unsafe at night.',
      imageUrl: 'assets/streetlight.png',
      location: const LatLng(23.7770, 86.4410),
      reportedOn: '26/07/2025, 11:00 am',
      currentStatus: 'Resolved',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Map Widget
            FlutterMap(
              options: const MapOptions(
                initialCenter: LatLng(
                  23.7788,
                  86.4382,
                ), // Changed from 'center' to 'initialCenter'
                initialZoom: 15.0, // Changed from 'zoom' to 'initialZoom'
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
                  markers: _dummyIssues.map<Marker>((issue) {
                    // Added explicit type <Marker>
                    Color markerColor = Colors.red;
                    if (issue.currentStatus == 'In Progress') {
                      markerColor = Colors.orange;
                    } else if (issue.currentStatus == 'Resolved') {
                      markerColor = Colors.green;
                    }
                    return Marker(
                      point: issue.location,
                      child: GestureDetector(
                        // Changed from 'builder' to 'child'
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
                  'FixMyCity',
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
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey[600]),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search "Kodarma, Jharkhand"',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Icon(Icons.mic_none, color: Colors.grey[600]),
                ],
              ),
            ),
          ],
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
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
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
                      // Issue Image
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
                      // Issue Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              issue.title,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Main Road, Near Bus Stop', // Dummy location for the card
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 5),
                            // Status Badge
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
                  // Report Statement
                  Text(
                    'Report Statement: ${issue.description}',
                    style: const TextStyle(fontSize: 16),
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
                  // Buttons
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
