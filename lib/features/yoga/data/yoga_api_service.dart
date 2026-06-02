import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../core/yoga_constants.dart';
import '../domain/pose_analysis_response.dart';

class YogaApiService {
  YogaApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<bool> checkConnection() async {
    try {
      final response = await _client
          .get(
            Uri.parse(
              '${YogaConstants.baseUrl}${YogaConstants.healthEndpoint}',
            ),
          )
          .timeout(
            const Duration(seconds: YogaConstants.connectionTimeoutSeconds),
          );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Yoga API connection failed: $e');
      return false;
    }
  }

  Future<String> imageToBase64(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    return base64Encode(bytes);
  }

  Future<PoseAnalysisResponse> detectPose({
    required File imageFile,
    required String targetPose,
  }) async {
    try {
      final imageBase64 = await imageToBase64(imageFile);
      final sessionId = DateTime.now().millisecondsSinceEpoch.toString();

      final response = await _client
          .post(
            Uri.parse(
              '${YogaConstants.baseUrl}${YogaConstants.detectPoseEndpoint}',
            ),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'imageBase64': imageBase64,
              'targetPose': targetPose,
              'sessionId': sessionId,
            }),
          )
          .timeout(
            const Duration(seconds: YogaConstants.analysisTimeoutSeconds),
          );

      if (response.statusCode != 200) {
        throw Exception('Server error: ${response.statusCode}');
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      return PoseAnalysisResponse.fromJson(decoded);
    } on TimeoutException {
      throw Exception('Request timed out. Check your connection.');
    } catch (e) {
      throw Exception('Analysis failed: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}
