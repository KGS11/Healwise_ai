import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../domain/analyzed_report.dart';

class ReportRepository {
  ReportRepository({FirebaseAuth? firebaseAuth, FirebaseFirestore? firestore})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
      _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  // Saves an analyzed report under users/{uid}/reports/{reportId}.
  Future<void> saveReport(AnalyzedReport report) async {
    final user = _firebaseAuth.currentUser;
    
    // Task 4: Verify FirebaseAuth.currentUser exists before saving
    debugPrint('[ReportRepository] [AUTH_CHECK] Verifying FirebaseAuth currentUser status...');
    if (user == null) {
      debugPrint('[ReportRepository] [AUTH_ERROR] FirebaseAuth.currentUser is NULL. Cannot proceed with cloud save.');
      throw const ReportRepositoryException(
        'Please login before saving reports.',
      );
    }
    
    debugPrint('[ReportRepository] [AUTH_SUCCESS] Authenticated user uid: ${user.uid}, email: ${user.email}');

    final docPath = 'users/${user.uid}/reports/${report.reportId}';
    debugPrint('[ReportRepository] [WRITE_START] Prepared write path: $docPath');
    debugPrint('[ReportRepository] [WRITE_DATA] Report toMap: ${report.toMap()}');

    try {
      debugPrint('[ReportRepository] [FIRESTORE_CALL] Invoking Firestore document set...');
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('reports')
          .doc(report.reportId)
          .set(report.toMap());
      debugPrint('[ReportRepository] [WRITE_SUCCESS] Firestore document successfully acknowledged by server or local cache.');
    } on FirebaseException catch (error, stack) {
      debugPrint('[ReportRepository] [WRITE_ERROR] FirebaseException occurred!');
      debugPrint('  Code: ${error.code}');
      debugPrint('  Message: ${error.message}');
      debugPrint('  Stacktrace: $stack');
      throw ReportRepositoryException(
        'Firebase Error (${error.code}): ${error.message ?? "Unknown database error"}',
      );
    } catch (error, stack) {
      debugPrint('[ReportRepository] [WRITE_ERROR] Unexpected error occurred during write!');
      debugPrint('  Error details: $error');
      debugPrint('  Stacktrace: $stack');
      throw ReportRepositoryException(
        'Unexpected Error: $error',
      );
    }
  }

  // Reads analyzed reports for the current authenticated user.
  Future<List<AnalyzedReport>> getReports() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw const ReportRepositoryException(
        'Please login before reading reports.',
      );
    }

    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('reports')
        .orderBy('uploadedAt', descending: true)
        .get();

    return snapshot.docs
      .map((doc) => AnalyzedReport.fromMap(doc.data()))
      .toList();
  }
}

class ReportRepositoryException implements Exception {
  const ReportRepositoryException(this.message);

  final String message;

  @override
  String toString() => message;
}
