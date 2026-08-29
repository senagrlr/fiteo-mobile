import 'package:cloud_firestore/cloud_firestore.dart';

class FatSecretBarcodeCacheRepository {
  final FirebaseFirestore _firestore;

  FatSecretBarcodeCacheRepository({
    FirebaseFirestore? firestore,
  }) : _firestore =
      firestore ?? FirebaseFirestore.instance;

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

  Future<String?> getFoodIdForBarcode(
      String barcode,
      ) async {
    final normalizedBarcode =
    normalizeBarcode(barcode);

    if (normalizedBarcode == null) {
      return null;
    }

    final doc = await _firestore
        .collection('fatSecretBarcodeAliases')
        .doc(normalizedBarcode)
        .get();

    final data = doc.data();

    if (data == null) {
      return null;
    }

    final foodId =
    data['foodId']?.toString();

    if (foodId == null ||
        foodId.trim().isEmpty) {
      return null;
    }

    return foodId.trim();
  }

  Future<void> saveBarcodeAlias({
    required String barcode,
    required String foodId,
  }) async {
    final normalizedBarcode =
    normalizeBarcode(barcode);

    if (normalizedBarcode == null ||
        foodId.trim().isEmpty) {
      return;
    }

    await _firestore
        .collection('fatSecretBarcodeAliases')
        .doc(normalizedBarcode)
        .set({
      'foodId': foodId.trim(),
      'updatedAt':
      FieldValue.serverTimestamp(),
    });
  }
}