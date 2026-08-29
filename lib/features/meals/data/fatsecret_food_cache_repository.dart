import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class FatSecretFoodCacheRepository {
  static const String _aliasUrl =
      'https://us-central1-fiteo-app-39f91.cloudfunctions.net/fatSecretFoodAlias';

  String normalizeQuery(String value) {
    return value
        .toLowerCase()
        .replaceAll('&', ' and ')
        .replaceAll(RegExp(r"['’]"), '')
        .replaceAll(RegExp(r'[^a-z0-9]+'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  Future<String?> _getIdToken() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return null;
    }

    final idToken = await user.getIdToken();

    if (idToken == null || idToken.isEmpty) {
      return null;
    }

    return idToken;
  }

  Future<String?> getFoodIdForQuery(
      String query,
      ) async {
    final normalizedQuery = normalizeQuery(query);

    if (normalizedQuery.isEmpty) {
      return null;
    }

    final idToken = await _getIdToken();

    if (idToken == null) {
      return null;
    }

    final uri = Uri.parse(
      '$_aliasUrl?q=${Uri.encodeQueryComponent(normalizedQuery)}',
    );

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );

    if (response.statusCode != 200) {
      return null;
    }

    final decoded =
    jsonDecode(response.body) as Map<String, dynamic>;

    final foodId =
    decoded['foodId']?.toString().trim();

    if (foodId == null || foodId.isEmpty) {
      return null;
    }

    return foodId;
  }

  Future<void> saveFoodAlias({
    required String query,
    required String foodId,
  }) async {
    final normalizedQuery = normalizeQuery(query);
    final cleanFoodId = foodId.trim();

    if (normalizedQuery.isEmpty || cleanFoodId.isEmpty) {
      return;
    }

    final idToken = await _getIdToken();

    if (idToken == null) {
      return;
    }

    await http.post(
      Uri.parse(_aliasUrl),
      headers: {
        'Authorization': 'Bearer $idToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'query': normalizedQuery,
        'foodId': cleanFoodId,
      }),
    );
  }
}