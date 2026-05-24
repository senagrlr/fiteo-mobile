import 'package:flutter/material.dart';
import 'package:fiteo_myapp/features/ai_coach/presentation/widgets/cook_mode/cook_welcome_view.dart';
import 'package:fiteo_myapp/features/ai_coach/presentation/widgets/cook_mode/cook_message_input.dart';
import 'package:fiteo_myapp/features/ai_coach/presentation/widgets/cook_mode/cook_loading_view.dart';
import 'package:fiteo_myapp/features/ai_coach/presentation/widgets/cook_mode/cook_recipe_dialog.dart';
import 'package:fiteo_myapp/features/ai_coach/presentation/widgets/shared/ai_mode_switch.dart';

class CookAiScreen extends StatefulWidget {
  final VoidCallback onSwitchToCoach;

  const CookAiScreen({
    super.key,
    required this.onSwitchToCoach,
  });

  @override
  State<CookAiScreen> createState() => _CookAiScreenState();
}

class _CookAiScreenState extends State<CookAiScreen> {
  final TextEditingController _ingredientController = TextEditingController();

  bool isGenerating = false;
  String? generatedRecipe;

  @override
  void dispose() {
    _ingredientController.dispose();
    super.dispose();
  }

  Future<void> _sendIngredients() async {
    final text = _ingredientController.text.trim();

    if (text.isEmpty || isGenerating) return;

    FocusScope.of(context).unfocus();

    setState(() {
      isGenerating = true;
    });

    _ingredientController.clear();

    final startTime = DateTime.now();

    await Future.delayed(const Duration(seconds: 1));

    generatedRecipe =
    'Recipe: Protein Veggie Bowl\n\n'
        'Ingredients:\n'
        '- $text\n'
        '- Olive oil\n'
        '- Salt and pepper\n\n'
        'Steps:\n'
        '1. Chop your ingredients.\n'
        '2. Cook them in a pan with olive oil.\n'
        '3. Add seasoning and mix well.\n'
        '4. Serve warm and enjoy.';

    final elapsed = DateTime.now().difference(startTime);
    const minimumDuration = Duration(seconds: 6);

    if (elapsed < minimumDuration) {
      await Future.delayed(minimumDuration - elapsed);
    }

    if (!mounted) return;

    setState(() {
      isGenerating = false;
    });

    await Future.delayed(const Duration(milliseconds: 250));

    if (!mounted) return;

    _showRecipeDialog();
  }

  void _showRecipeDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.22),
      builder: (context) {
        return CookRecipeDialog(
          recipe: generatedRecipe ?? '',
          onAddToIntake: () {
            Navigator.pop(context);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Recipe added to intake.'),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: Stack(
              children: [
                Positioned(
                  top: 22,
                  right: 28,
                  child: AiModeSwitch(
                    isCookMode: true,
                    onChanged: (_) => widget.onSwitchToCoach(),
                  ),
                ),

                Column(
                  children: [
                    const Spacer(flex: 3),

                    const CookWelcomeView(),

                    const SizedBox(height: 30),

                    CookMessageInput(
                      controller: _ingredientController,
                      onSend: _sendIngredients,
                      horizontalPadding: 28,
                      bottomPadding: 0,
                    ),

                    const Spacer(flex: 3),
                  ],
                ),
              ],
            ),
          ),

          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            child: isGenerating
                ? const CookLoadingView(
              key: ValueKey('cook-loading'),
            )
                : const SizedBox.shrink(
              key: ValueKey('cook-empty'),
            ),
          ),
        ],
      ),
    );
  }
}