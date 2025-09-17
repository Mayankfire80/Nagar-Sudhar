// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:fix_my_city/screens/notifications_screen.dart';
import 'package:fix_my_city/screens/settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy Data for the profile
    const String userName = 'Avni Gupta';
    const int reports = 15;
    const int points = 1250;
    const int pointsToNextLevel = 130;
    const int achievements = 50;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildAppBar(context),
              _buildProfileCard(
                userName,
                reports,
                points,
                pointsToNextLevel,
                achievements,
              ),
              _buildAchievementsSection(),
            ],
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
              // Brightness Icon
              Icon(Icons.brightness_7, color: Colors.yellow[700]),
              const SizedBox(width: 10),
              const Text(
                'Good Morning',
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

  Widget _buildProfileCard(
    String name,
    int reports,
    int points,
    int pointsToNextLevel,
    int achievements,
  ) {
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
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'level 5 :',
                      style: TextStyle(fontSize: 14, color: Colors.green),
                    ),
                    const Text(
                      'URBAN PIONEER',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Stack(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage(
                        'assets/avni_gupta.png',
                      ), // Add this image
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _buildInfoBadge('$reports reports', Colors.black),
                const SizedBox(width: 10),
                _buildInfoBadge('$points points', Colors.black),
              ],
            ),
            const SizedBox(height: 10),
            _buildInfoBadge(
              '$pointsToNextLevel points to level 6',
              Colors.red,
              isSpecial: true,
            ),
            const SizedBox(height: 10),
            _buildInfoBadge('$achievements achievements', Colors.black),
            const SizedBox(height: 20),
            const Text(
              'Let\'s do this! Report issues to level up.',
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBadge(
    String text,
    Color textColor, {
    bool isSpecial = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSpecial ? Colors.yellow[700] : Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildAchievementsSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
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
                  Row(
                    children: [
                      const Icon(
                        Icons.emoji_events,
                        color: Colors.orange,
                        size: 28,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Your Achieve\nments',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  _buildAchievementItem('Pothole Hunter:', 'Report 5 potholes'),
                  _buildAchievementItem(
                    'Change Maker:',
                    '3 of your reports get resolved',
                  ),
                  _buildAchievementItem(
                    'Civic Influencer:',
                    '20 people confirm your report',
                  ),
                  _buildAchievementItem(
                    'First Step:',
                    'Submit your first issue',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          _buildLevelTimeline(),
        ],
      ),
    );
  }

  Widget _buildAchievementItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            description,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelTimeline() {
    return Container(
      width: 100, // Fixed width for the timeline
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const RotatedBox(
            quarterTurns: -1,
            child: Text('eco guardian', style: TextStyle(color: Colors.grey)),
          ),
          const SizedBox(height: 20),
          const RotatedBox(
            quarterTurns: -1,
            child: Text('City Builder', style: TextStyle(color: Colors.grey)),
          ),
          const SizedBox(height: 20),
          _buildCurrentLevelBadge(),
          const SizedBox(height: 20),
          const RotatedBox(
            quarterTurns: -1,
            child: Text(
              'Neighborhood Guardian',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 20),
          const RotatedBox(
            quarterTurns: -1,
            child: Text('Citizen Scout', style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentLevelBadge() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.yellow,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(Icons.code, color: Colors.black, size: 20),
    );
  }
}
