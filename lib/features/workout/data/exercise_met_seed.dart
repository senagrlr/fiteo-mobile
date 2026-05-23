import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class ExerciseMetSeed {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> uploadExerciseMetValues() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/exercise_met_values.json',
    );

    final List<dynamic> items = jsonDecode(jsonString);

    final batch = _firestore.batch();

    for (final item in items) {
      final id = item['id']?.toString();

      if (id == null || id.isEmpty) {
        continue;
      }

      final docRef = _firestore.collection('exerciseMetValues').doc(id);

      batch.set(docRef, {
        'name': item['name'],
        'aliases': item['aliases'],
        'metValues': item['metValues'],
      });
    }

    await batch.commit();
  }
}