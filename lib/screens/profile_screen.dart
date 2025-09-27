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
    const int currentLevel = 3;

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
              children: [
                _buildAppBar(context),
                _buildProfileCard(
                  userName,
                  reports,
                  points,
                  pointsToNextLevel,
                  achievements,
                ),
                _buildAchievementsSection(context, currentLevel),
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
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 30.0,
              vertical: 8.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
                      radius: 50,
                      backgroundImage: AssetImage('assets/avni_gupta.png'),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoBadge('$reports reports', Colors.black),
                const SizedBox(height: 10),
                _buildInfoBadge('$points points', Colors.black),
                const SizedBox(height: 10),
                _buildInfoBadge(
                  '$pointsToNextLevel points to level 6',
                  Colors.red,
                  isSpecial: true,
                ),
                const SizedBox(height: 10),
                _buildInfoBadge('$achievements achievements', Colors.black),
              ],
            ),
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

  Widget _buildAchievementsSection(BuildContext context, int currentLevel) {
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
                        'Your \nAchievements',
                        style: TextStyle(
                          fontSize: 14,
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
          Expanded(child: _buildLevelTimeline(context, currentLevel)),
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
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Text(
            description,
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  // lib/screens/profile_screen.dart

  Widget _buildLevelTimeline(BuildContext context, int currentLevel) {
    // Height of the timeline area
    const double timelineHeight = 280;

    // A map to store the position of each level
    final Map<String, double> levelPositions = {
      'Citizen Scout': 0.0,
      'Neighborhood Guardian': 0.25,
      'Urban Pioneer': 0.5,
      'City Builder': 0.75,
      'eco guardian': 1.0,
    };

    String getLevelName(int level) {
      if (level == 1) return 'Citizen Scout';
      if (level == 2) return 'Neighborhood Guardian';
      if (level == 3) return 'Urban Pioneer';
      if (level == 4) return 'City Builder';
      return 'eco guardian';
    }

    return Container(
      height: timelineHeight + 40, // Add some extra height for spacing
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
      child: Stack(
        children: [
          // The main vertical line
          Positioned(
            left: 40, // Adjust left position to align with text
            top: 0,
            bottom: 0,
            child: Container(
              width: 4,
              decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Text Labels on the Left
          Positioned(
            left: 60, // Adjusted left to create a gap
            top: timelineHeight * levelPositions['Urban Pioneer']! - 5,
            child: Text(
              'Urban Pioneer',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
            ),
          ),
          Positioned(
            left: 60, // Adjusted left to create a gap
            top: timelineHeight * levelPositions['Neighborhood Guardian']! + 5,
            child: Text(
              'Neighborhood Guardian',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
            ),
          ),
          Positioned(
            left: 60, // Adjusted left to create a gap
            top: timelineHeight * levelPositions['Citizen Scout']! + 20,
            child: Text(
              'Citizen Scout',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
            ),
          ),

          // Text Labels on the Right
          Positioned(
            left: 60, // Adjusted right to create a gap
            top: timelineHeight * levelPositions['eco guardian']! - 40,
            child: Text(
              'eco guardian',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
            ),
          ),
          Positioned(
            left: 60, // Adjusted right to create a gap
            top: timelineHeight * levelPositions['City Builder']! - 20,
            child: Text(
              'City Builder',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
            ),
          ),

          // The Current Level Badge (dynamic position)
          Positioned(
            left: 30, // Adjust left to be on the line
            top:
                timelineHeight * levelPositions[getLevelName(currentLevel)]! -
                15, // This is the dynamic part!
            child: _buildCurrentLevelBadge(context), // Pass context here
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentLevelBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.yellow,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.yellow.withOpacity(0.4),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: const Icon(Icons.keyboard_arrow_up, color: Colors.black, size: 20),
    );
  }
}