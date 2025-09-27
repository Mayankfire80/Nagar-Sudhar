// lib/models/issue_data_model.dart
import 'package:latlong2/latlong.dart';

class IssueData {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final LatLng location;
  final String reportedOn;
  final String currentStatus; 
  final int upvotes;
  final int downvotes;
  final String category; // Essential for filtering/backend
  final String severity; // Essential for prioritization
  final String? assignedTo; // Added for transparency (Admin Portal)

  IssueData({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.location,
    required this.reportedOn,
    required this.currentStatus,
    this.category = 'Other', 
    this.severity = 'Low', 
    this.upvotes = 0,
    this.downvotes = 0,
    this.assignedTo, // Added to constructor
  });
  
  // RIVERPOD REQUIREMENT: Method to create a new instance with updated values (immutable update)
  IssueData copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    LatLng? location,
    String? reportedOn,
    String? currentStatus,
    int? upvotes,
    int? downvotes,
    String? category,
    String? severity,
    String? assignedTo,
  }) {
    return IssueData(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      location: location ?? this.location,
      reportedOn: reportedOn ?? this.reportedOn,
      currentStatus: currentStatus ?? this.currentStatus,
      upvotes: upvotes ?? this.upvotes,
      downvotes: downvotes ?? this.downvotes,
      category: category ?? this.category,
      severity: severity ?? this.severity,
      assignedTo: assignedTo ?? this.assignedTo,
    );
  }
}