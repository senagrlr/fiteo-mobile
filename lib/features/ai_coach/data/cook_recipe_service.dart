import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fiteo_myapp/features/ai_coach/data/cook_recipe_result.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CookRecipeService {
  static const String _recipeUrl =
      'https://generaterecipefromingredients-3qn3ngl7rq-uc.a.run.app';

  Future<CookRecipeResult?> generateRecipe({
    required String ingredientsText,
    required Map<String, dynamic> preferences,
  }) async {
    final trimmedInput = ingredientsText.trim();

    if (trimmedInput.isEmpty) return null;

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        return null;
      }

      final idToken = await user.getIdToken();

      if (idToken == null || idToken.isEmpty) {
        return null;
      }

      final response = await http
          .post(
        Uri.parse(_recipeUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
        body: jsonEncode({
          'ingredients': trimmedInput,
          'preferences': preferences,
        }),
      )
          .timeout(const Duration(seconds: 35));

      if (response.statusCode != 200) {
        return null;
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;

      return CookRecipeResult.fromJson(decoded);
    } catch (_) {
      return null;
    }
  }
}