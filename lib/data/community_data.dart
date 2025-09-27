import 'package:flutter/material.dart';

// 1. Data Model Class for Leaderboard Entry
class LeaderboardEntry {
  final String name;
  final int points;
  final int rank;
  final String imageUrl;

  const LeaderboardEntry({
    required this.name,
    required this.points,
    required this.rank,
    required this.imageUrl,
  });
}

// 2. Centralized Dummy Data List
final List<LeaderboardEntry> initialLeaderboardData = [
  const LeaderboardEntry(
    name: 'Avni Gupta',
    points: 1250,
    rank: 1,
    imageUrl: 'assets/avni_gupta.png',
  ),
  const LeaderboardEntry(
    name: 'Arjun Sharma',
    points: 1180,
    rank: 2,
    imageUrl: 'assets/arjun_sharma.png',
  ),
  const LeaderboardEntry(
    name: 'Priya Singh',
    points: 950,
    rank: 3,
    imageUrl: 'assets/priya_singh.png',
  ),
  const LeaderboardEntry(
    name: 'Rajesh Kumar',
    points: 810,
    rank: 4,
    imageUrl: 'assets/rajesh_kumar.png',
  ),
  const LeaderboardEntry(
    name: 'Meera Patel',
    points: 720,
    rank: 5,
    imageUrl: 'assets/meera_patel.png',
  ),
];