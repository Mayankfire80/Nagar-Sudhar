// lib/repositories/reports_repository.dart

import 'package:fix_my_city/models/issue_data_model.dart';
import 'package:fix_my_city/data/reports_data.dart';

// 🔥 FIX 1: Reduced mock delay to 50ms for a snappy feel
class ReportsRepository {
  final Duration _mockDelay = const Duration(milliseconds: 50); 
  
  // MOCK IMAGE URLS: Use real placeholder URLs for testing network loading
  String _getMockImageUrl(String category) {
    // A slightly more robust mapping for categories
    final lowerCategory = category.toLowerCase();
    if (lowerCategory.contains('pothole')) {
      return 'https://picsum.photos/seed/pothole${DateTime.now().millisecond}/400/300';
    } else if (lowerCategory.contains('litter') || lowerCategory.contains('garbage')) {
      return 'https://picsum.photos/seed/litter${DateTime.now().millisecond}/400/300';
    } else if (lowerCategory.contains('streetlight')) {
      return 'https://picsum.photos/seed/streetlight${DateTime.now().millisecond}/400/300';
    } else if (lowerCategory.contains('leak') || lowerCategory.contains('water')) {
      return 'https://picsum.photos/seed/waterleak${DateTime.now().millisecond}/400/300';
    } else if (lowerCategory.contains('sign') || lowerCategory.contains('damaged')) {
      return 'https://picsum.photos/seed/sign${DateTime.now().millisecond}/400/300';
    } else if (lowerCategory.contains('dumping')) {
      return 'https://picsum.photos/seed/dumping${DateTime.now().millisecond}/400/300';
    } else if (lowerCategory.contains('graffiti')) {
      return 'https://picsum.photos/seed/graffiti${DateTime.now().millisecond}/400/300';
    }
    // Fallback for 'Other' or unhandled categories, using a consistent seed
    return 'https://picsum.photos/seed/cityissue${DateTime.now().millisecond}/400/300';
  }

  // --- READ OPERATIONS ---

  Future<List<IssueData>> fetchAllReports() async {
    await Future.delayed(_mockDelay);
    return initialDummyReports;
  }

  Future<IssueData?> fetchReportById(String id) async {
    await Future.delayed(_mockDelay);
    return initialDummyReports.firstWhere(
      (report) => report.id == id,
      orElse: () => throw Exception('Report not found'),
    );
  }

  // --- WRITE OPERATIONS (MOCK UPLOAD) ---

  // Submits a new report to the "backend"
  Future<IssueData> submitNewReport(IssueData report) async {
    await Future.delayed(_mockDelay);
    
    // Simulate uploading the file path to a cloud service.
    final cloudImageUrl = _getMockImageUrl(report.category);

    final submittedReport = report.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      reportedOn: 'Just now', // Removed "(from mock cloud)"
      imageUrl: cloudImageUrl, // Saved as a URL, not a local path!
    );
    print('MOCK: Report submitted and given cloud URL: $cloudImageUrl');
    return submittedReport;
  }
}