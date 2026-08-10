import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiteo_myapp/features/ai_coach/data/cook_recipe_result.dart';

class SavedRecipeRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> saveRecipe(
      CookRecipeResult recipe,
      ) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    final docRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('savedRecipes')
        .doc();

    await docRef.set({
      'recipeName': recipe.recipeName,
      'ingredients': recipe.ingredients.map((ingredient) {
        return {
          'name': ingredient.name,
          'amount': ingredient.amount,
          'calories': ingredient.calories,
        };
      }).toList(),
      'instructions': recipe.instructions,
      'totalCalories': recipe.totalCalories,
      'servings': recipe.servings,
      'caloriesPerServing': recipe.caloriesPerServing,
      'proteinPerServing': recipe.proteinPerServing,
      'fatPerServing': recipe.fatPerServing,
      'carbsPerServing': recipe.carbsPerServing,
      'allergens': recipe.allergens,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return docRef.id;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getSavedRecipes() async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('savedRecipes')
        .orderBy('createdAt', descending: true)
        .get();
  }

  Future<void> deleteSavedRecipe(
      String recipeId,
      ) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('savedRecipes')
        .doc(recipeId)
        .delete();
  }
}