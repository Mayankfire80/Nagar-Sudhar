// lib/data/reports_data.dart
import 'package:fix_my_city/models/issue_data_model.dart';
import 'package:latlong2/latlong.dart';

final List<IssueData> initialDummyReports = [
  IssueData(
    id: '1',
    title: 'Large Pothole on Main Str.',
    description: 'Huge pothole causing traffic jam and damage to bikes.',
    imageUrl: 'assets/pothole1.png', // Using local asset for prototype stability
    location: const LatLng(23.7788, 86.4382),
    reportedOn: '12 hours ago',
    currentStatus: 'in progress',
    category: 'Pothole',
    severity: 'High',
    upvotes: 5,
    downvotes: 1,
    assignedTo: 'Worker 101',
  ),
  IssueData(
    id: '2',
    title: 'Sewer Leakage',
    description: 'Major leakage near the bus stop causing a bad smell.',
    imageUrl: 'assets/sewer_leakage.png',
    location: const LatLng(23.7795, 86.4395),
    reportedOn: '12 hours ago',
    currentStatus: 'pending',
    category: 'Water Leak',
    severity: 'Urgent',
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
    category: 'Broken Streetlight',
    severity: 'Medium',
    upvotes: 10,
    downvotes: 0,
  ),
  IssueData(
    id: '4',
    title: 'Illegal Garbage Dumping',
    description: 'Large pile of garbage dumped next to school boundary wall.',
    imageUrl: 'assets/trash_bins.png',
    location: const LatLng(23.7790, 86.4370),
    reportedOn: '8 hours ago',
    currentStatus: 'pending',
    category: 'Illegal Dumping',
    severity: 'Medium',
    upvotes: 3,
    downvotes: 0,
  ),
];