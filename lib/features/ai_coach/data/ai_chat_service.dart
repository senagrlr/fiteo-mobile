import 'dart:convert';

import 'package:http/http.dart' as http;

class AiChatService {
  static const String _chatUrl =
      'https://chatwithcoach-3qn3ngl7rq-uc.a.run.app';

  Future<String?> sendMessage({
    required String message,
    required Map<String, dynamic> userPreferences,
    required Map<String, dynamic> dailySummary,
    required List<Map<String, dynamic>> last7Summaries,
    required List<Map<String, dynamic>> recentMessages,
  }) async {
    try {
      final uri = Uri.parse(_chatUrl);

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'message': message,
          'userPreferences': userPreferences,
          'dailySummary': dailySummary,
          'last7Summaries': last7Summaries,
          'recentMessages': recentMessages,
        }),
      );

      if (response.statusCode != 200) {
        return null;
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;

      return decoded['reply'] as String?;
    } catch (_) {
      return null;
    }
  }
}