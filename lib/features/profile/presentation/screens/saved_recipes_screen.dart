import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/saved_recipe_card.dart';

class SavedRecipesScreen extends StatelessWidget {
  const SavedRecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final savedRecipes = <Map<String, dynamic>>[
      // Test etmek için listeyi boş bırak:
      // {'name': 'Pizza', 'calories': 250},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.homeBrown,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Saved Recipes',
          style: TextStyle(
            color: AppColors.homeBrown,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: savedRecipes.isEmpty
          ? const _EmptySavedRecipes()
          : GridView.builder(
        padding: const EdgeInsets.fromLTRB(
          32,
          20,
          32,
          40,
        ),
        itemCount: savedRecipes.length,
        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 18,
          mainAxisSpacing: 28,
          childAspectRatio: 1.55,
        ),
        itemBuilder: (context, index) {
          final recipe = savedRecipes[index];

          return SavedRecipeCard(
            recipeName: recipe['name'] as String,
            calories: recipe['calories'] as int,
            onTap: () {
              // Tarif detay sayfasına yönlendirme
            },
          );
        },
      ),
    );
  }
}

class _EmptySavedRecipes extends StatelessWidget {
  const _EmptySavedRecipes();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform.translate(
        offset: const Offset(0, -30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: SizedBox(
                width: 320,
                height: 320,
                child: Lottie.asset(
                  'assets/animations/empty.json',
                  repeat: true,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(height: 2),

            const Text(
              'No saved recipes yet.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFB5B5B5),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}