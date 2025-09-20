// lib/models/issue_data_model.dart
import 'package:latlong2/latlong.dart';

class IssueData {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final LatLng location;
  final String reportedOn;
  String currentStatus; // Made mutable
  int upvotes; // Added
  int downvotes; // Added

  IssueData({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.location,
    required this.reportedOn,
    required this.currentStatus,
    this.upvotes = 0,
    this.downvotes = 0,
  });
}