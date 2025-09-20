// main.dart
import 'package:flutter/material.dart';
import 'package:fix_my_city/screens/home_screen.dart';
import 'package:fix_my_city/screens/map_screen.dart';
import 'package:fix_my_city/screens/reports_screen.dart';
import 'package:fix_my_city/screens/community_screen.dart';
import 'package:fix_my_city/screens/profile_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fix_my_city/models/issue_data_model.dart';
import 'package:latlong2/latlong.dart';
import 'package:fix_my_city/screens/new_report_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nagar Sudhar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.red,
        fontFamily: 'Montserrat',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const MainAppWrapper(),
    );
  }
}

class MainAppWrapper extends StatefulWidget {
  const MainAppWrapper({super.key});

  @override
  State<MainAppWrapper> createState() => _MainAppWrapperState();
}

class _MainAppWrapperState extends State<MainAppWrapper> {
  int _selectedIndex = 0;

  final List<IssueData> _reports = [
    IssueData(
      id: '1',
      title: 'Large Pothole on Main Str.',
      description: 'Huge pothole causing traffic jam and damage to bikes.',
      imageUrl: 'assets/pothole1.png',
      location: const LatLng(23.7788, 86.4382),
      reportedOn: '12 hours ago',
      currentStatus: 'in progress',
      upvotes: 5,
      downvotes: 1,
    ),
    IssueData(
      id: '2',
      title: 'Sewer Leakage',
      description: 'Major leakage near the bus stop causing a bad smell.',
      imageUrl: 'assets/sewer_leakage.png',
      location: const LatLng(23.7795, 86.4395),
      reportedOn: '12 hours ago',
      currentStatus: 'pending',
      upvotes: 2,
      downvotes: 0,
    ),
    IssueData(
      id: '3',
      title: 'Streetlight Not Working',
      description: 'Streetlight out, making the area unsafe at night.',
      imageUrl: 'assets/streetlight.png',
      location: const LatLng(23.7770, 86.4410),
      reportedOn: '12 hours ago',
      currentStatus: 'resolved',
      upvotes: 10,
      downvotes: 0,
    ),
  ];

  void _addReport(IssueData newReport) {
    setState(() {
      _reports.insert(0, newReport);
    });
  }

  void _onUpvote(int index) {
    setState(() {
      _reports[index].upvotes++;
    });
  }

  void _onDownvote(int index) {
    setState(() {
      _reports[index].downvotes++;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: _selectedIndex,
            children: [
              HomeScreen(
                reports: _reports,
                onViewAllTapped: () => _onItemTapped(2),
                addReport: _addReport,
                onUpvote: _onUpvote,
                onDownvote: _onDownvote,
              ),
              MapScreen(reports: _reports),
              ReportsScreen(reports: _reports, onUpvote: _onUpvote, onDownvote: _onDownvote),
              const CommunityScreen(),
              const ProfileScreen(),
            ],
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 15, right: 15),
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black
                      : Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavBarItem(
                      context,
                      'Home',
                      'assets/icons/home.svg',
                      0,
                    ),
                    _buildNavBarItem(context, 'Map', 'assets/icons/map.svg', 1),
                    _buildNavBarItem(
                      context,
                      'Reports',
                      'assets/icons/reports.svg',
                      2,
                    ),
                    _buildNavBarItem(
                      context,
                      'Community',
                      'assets/icons/community.svg',
                      3,
                    ),
                    _buildNavBarItem(
                      context,
                      'Profile',
                      'assets/icons/profile.svg',
                      4,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavBarItem(
    BuildContext context,
    String title,
    String iconPath,
    int index,
  ) {
    final isSelected = _selectedIndex == index;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    Color itemColor = isSelected
        ? (isDarkMode ? Colors.white : Colors.white)
        : (isDarkMode ? Colors.grey[600]! : Colors.grey);
    Color textColor = isSelected
        ? (isDarkMode ? Colors.white : Colors.black)
        : (isDarkMode ? Colors.grey : Colors.grey[600]!);
    Color boxColor = isDarkMode ? Colors.white : Colors.black;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 50,
          height: 60,
          decoration: isSelected
              ? BoxDecoration(
                  color: boxColor,
                  borderRadius: BorderRadius.circular(15),
                )
              : null,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  iconPath,
                  colorFilter: ColorFilter.mode(itemColor, BlendMode.srcIn),
                  height: 24,
                  width: 24,
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: TextStyle(
                    color: itemColor,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 8,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}