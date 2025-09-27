// lib/providers/reports_provider.dart (UPDATED with Navigation Provider)

import 'package:riverpod/riverpod.dart';
import 'package:fix_my_city/models/issue_data_model.dart';
import 'package:fix_my_city/repositories/reports_repository.dart'; 


// 1. Repository Provider (No Change)
final reportsRepositoryProvider = Provider((ref) => ReportsRepository());

// 2. Filter State Provider (NEW)
final reportsFilterProvider = StateProvider<String>((ref) => 'All');

// 3. Notifier (Action Logic)
class ReportsNotifier extends StateNotifier<List<IssueData>> {
  final ReportsRepository _repository;

  ReportsNotifier(this._repository) : super([]);

  Future<void> loadReports() async {
    final reports = await _repository.fetchAllReports();
    state = reports;
  }

  Future<void> addReport(IssueData newReport) async {
    final submittedReport = await _repository.submitNewReport(newReport);
    state = [submittedReport, ...state];
  }

  void upvoteReport(String reportId) {
    state = [
      for (final report in state)
        if (report.id == reportId)
          report.copyWith(upvotes: report.upvotes + 1)
        else
          report,
    ];
  }

  void downvoteReport(String reportId) {
    state = [
      for (final report in state)
        if (report.id == reportId)
          report.copyWith(downvotes: report.downvotes + 1)
        else
          report,
    ];
  }
}

// 4. Base Reports Provider (No Change)
final reportsProvider = StateNotifierProvider<ReportsNotifier, List<IssueData>>((ref) {
  final repository = ref.watch(reportsRepositoryProvider);
  return ReportsNotifier(repository);
});

// 5. Filtered Reports Provider (NEW)
final filteredReportsProvider = Provider<List<IssueData>>((ref) {
  final reports = ref.watch(reportsProvider);
  final filter = ref.watch(reportsFilterProvider);

  if (filter == 'All') {
    return reports;
  }

  if (filter == 'Pending') {
    return reports.where((r) => r.currentStatus.toLowerCase() == 'pending').toList();
  }
  
  if (filter == 'Urgent') {
    return reports.where((r) => r.severity.toLowerCase() == 'urgent').toList();
  }
  
  if (filter == 'Assigned') {
    return reports.where((r) => r.assignedTo != null && r.currentStatus.toLowerCase() == 'in progress').toList();
  }
  
  if (filter == 'In Progress') {
     return reports.where((r) => r.currentStatus.toLowerCase() == 'in progress').toList();
  }

  if (filter == 'Resolved') {
     return reports.where((r) => r.currentStatus.toLowerCase() == 'resolved').toList();
  }

  return reports;
});

// 🔥 NEW: Navigation State Provider
// Manages the selected index of the main bottom navigation bar (0=Home, 2=Reports)
final navigationIndexProvider = StateProvider<int>((ref) => 0);