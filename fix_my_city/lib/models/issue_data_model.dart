// lib/models/issue_data_model.dart
import 'package:latlong2/latlong.dart';

class IssueData {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final LatLng location; // This will hold the latitude and longitude for the map
  final String reportedOn;
  final String currentStatus;

  IssueData({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.location,
    required this.reportedOn,
    required this.currentStatus,
  });
}