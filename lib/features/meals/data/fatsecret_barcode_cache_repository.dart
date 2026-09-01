import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class FatSecretBarcodeCacheRepository {
  static const String _aliasUrl =
      'https://us-central1-fiteo-app-39f91.cloudfunctions.net/fatSecretBarcodeAlias';

  String? normalizeBarcode(String value) {
    final digits =
    value.replaceAll(RegExp(r'\D'), '');

    if (digits.length == 13) {
      return digits;
    }

    if (digits.length == 12 ||
        digits.length == 8) {
      return digits.padLeft(13, '0');
    }

    return null;
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

  Future<String?> getFoodIdForBarcode(
      String barcode,
      ) async {
    final normalizedBarcode =
    normalizeBarcode(barcode);

    if (normalizedBarcode == null) {
      return null;
    }

    final idToken = await _getIdToken();

    if (idToken == null) {
      return null;
    }

    final uri = Uri.parse(
      '$_aliasUrl?barcode=${Uri.encodeQueryComponent(normalizedBarcode)}',
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

  Future<void> saveBarcodeAlias({
    required String barcode,
    required String foodId,
  }) async {
    final normalizedBarcode =
    normalizeBarcode(barcode);

    final cleanFoodId = foodId.trim();

    if (normalizedBarcode == null ||
        cleanFoodId.isEmpty) {
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
        'barcode': normalizedBarcode,
        'foodId': cleanFoodId,
      }),
    );
  }
}