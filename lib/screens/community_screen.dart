import 'package:flutter/material.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  // Dummy data for the leaderboard
  final List<Map<String, dynamic>> _leaderboard = const [
    {'name': 'Avni Gupta', 'points': 1250, 'rank': 1, 'image': 'assets/avni_gupta.png'},
    {'name': 'Arjun Sharma', 'points': 1180, 'rank': 2, 'image': 'assets/arjun_sharma.png'},
    {'name': 'Priya Singh', 'points': 950, 'rank': 3, 'image': 'assets/priya_singh.png'},
    {'name': 'Rajesh Kumar', 'points': 810, 'rank': 4, 'image': 'assets/rajesh_kumar.png'},
    {'name': 'Meera Patel', 'points': 720, 'rank': 5, 'image': 'assets/meera_patel.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Community', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.grey[100],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLeaderboardSection(),
              const SizedBox(height: 20),
              _buildMunicipalTrustSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeaderboardSection() {
    return Container(
      padding: const EdgeInsets.all(16),
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
            'Leaderboard',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(), // To avoid nested scrolling
            itemCount: _leaderboard.length,
            itemBuilder: (context, index) {
              final user = _leaderboard[index];
              return _buildLeaderboardItem(
                user['rank'],
                user['name'],
                user['points'],
                user['image'],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardItem(int rank, String name, int points, String imageUrl) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            '#$rank',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[700]),
          ),
          const SizedBox(width: 15),
          CircleAvatar(
            backgroundImage: AssetImage(imageUrl),
            radius: 20,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            '$points pts',
            style: const TextStyle(fontSize: 16, color: Colors.redAccent, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildMunicipalTrustSection() {
    return Container(
      padding: const EdgeInsets.all(16),
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
            'Municipal Trust Index',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            'Near Area Municipal Corporation',
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
          const SizedBox(height: 10),
          // We can use a linear progress indicator or a custom gauge for this
          LinearProgressIndicator(
            value: 0.85, // Example value for 85% trust
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blueAccent),
          ),
          const SizedBox(height: 5),
          const Text(
            '85% Trusted',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueAccent),
          ),
          const SizedBox(height: 10),
          // This section would show user voting on resolved issues
          const Text(
            'Vote on resolved issues to give feedback on their work quality.',
            style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}