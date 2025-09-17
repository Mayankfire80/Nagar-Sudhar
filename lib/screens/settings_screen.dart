// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(context, 'Account'),
              _buildSettingsOption(context, Icons.person_outline, 'Edit Profile'),
              _buildSettingsOption(context, Icons.lock_outline, 'Change Password'),
              _buildSettingsOption(context, Icons.notifications_none, 'Notification Preferences'),
              const Divider(),
              _buildSectionTitle(context, 'App'),
              _buildSettingsOption(context, Icons.language, 'Language'),
              _buildSettingsOption(context, Icons.info_outline, 'About Us'),
              _buildSettingsOption(context, Icons.contact_support_outlined, 'Help & Support'),
              const Divider(),
              _buildSectionTitle(context, 'Legal'),
              _buildSettingsOption(context, Icons.policy_outlined, 'Privacy Policy'),
              _buildSettingsOption(context, Icons.description_outlined, 'Terms of Service'),
              const Divider(),
              _buildLogoutButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  Widget _buildSettingsOption(BuildContext context, IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[800]),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {
        // Handle navigation to the specific setting screen
      },
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Center(
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.redAccent,
          side: const BorderSide(color: Colors.redAccent),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        ),
        onPressed: () {
          // Handle logout
        },
        child: const Text(
          'Log Out',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}