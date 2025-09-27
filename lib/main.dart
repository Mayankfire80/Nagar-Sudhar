// lib/main.dart
import 'package:flutter/material.dart';
// 🔥 RIVERPOD: Import Riverpod packages
import 'package:flutter_riverpod/flutter_riverpod.dart'; 
import 'package:fix_my_city/providers/reports_provider.dart';
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
  // 🔥 RIVERPOD: Wrap the app in ProviderScope
  runApp(const ProviderScope(child: MyApp())); 
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // 🔥 NEW: Define the maximum width for the mobile view on desktop
  static const double _maxWidth = 450.0;

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
      // 🔥 FIX: Center and constrain the app view for web/desktop
      home: const Center(
        child: SizedBox(
          width: _maxWidth,
          child: MainAppWrapper(),
        ),
      ),
    );
  }
}

// 🔥 RIVERPOD: Change to ConsumerStatefulWidget
class MainAppWrapper extends ConsumerStatefulWidget {
  const MainAppWrapper({super.key});

  @override
  ConsumerState<MainAppWrapper> createState() => _MainAppWrapperState();
}

// 🔥 RIVERPOD: Change to ConsumerState
class _MainAppWrapperState extends ConsumerState<MainAppWrapper> {
  // 🚫 REMOVED: int _selectedIndex = 0;

  // 🔥 NEW: Load reports when the widget is initialized
  @override
  void initState() {
    super.initState();
    // Start loading the initial data from the mock repository
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(reportsProvider.notifier).loadReports();
    });
  }

  void _onItemTapped(int index) {
    // 🔥 NEW: Update the provider state
    ref.read(navigationIndexProvider.notifier).state = index;
  }

  @override
  Widget build(BuildContext context) {
    // 🔥 NEW: Watch the provider for the selected index
    final int selectedIndex = ref.watch(navigationIndexProvider); 
    
    // 🔥 RIVERPOD: Watch the reports list from the provider
    final List<IssueData> reports = ref.watch(reportsProvider); 

    // 🔥 NEW: Show loading spinner if reports are empty (while fetching)
    if (reports.isEmpty) {
      // Check if we are still waiting for initial data load
      if (ref.watch(reportsProvider.notifier).state.isEmpty) {
         return const Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Colors.redAccent),
                SizedBox(height: 16),
                Text("Loading civic data..."),
              ],
            ),
          ),
        );
      }
    }

    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: selectedIndex, // 🔥 Use provider value
            children: [
              HomeScreen(
                reports: reports,
                onViewAllTapped: () => _onItemTapped(2),
              ),
              MapScreen(), // FIX: Removed 'reports: reports' parameter
              ReportsScreen(reports: reports),
              CommunityScreen(),
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
    // 🔥 NEW: Use provider value for comparison
    final isSelected = ref.watch(navigationIndexProvider) == index; 
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
        // 🔥 NEW: Call _onItemTapped (which updates the provider)
        _onItemTapped(index);
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