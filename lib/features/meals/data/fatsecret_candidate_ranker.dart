import 'package:fiteo_myapp/features/meals/data/fatsecret_api_service.dart';

class FatSecretCandidateRanker {
  const FatSecretCandidateRanker._();

  static const Set<String> _stopWords = {
    'a',
    'an',
    'the',
    'of',
    'with',
    'and',
  };

  static const Set<String> _criticalVariants = {
    'zero',
    'light',
  };

  static String _normalize(String value) {
    return value
        .toLowerCase()
        .replaceAll('&', ' and ')
        .replaceAll(RegExp(r"['’]"), '')
        .replaceAll(RegExp(r'[^a-z0-9]+'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  static Set<String> _tokens(String value) {
    return _normalize(value)
        .split(' ')
        .where(
          (token) =>
      token.isNotEmpty &&
          !_stopWords.contains(token),
    )
        .toSet();
  }

  static bool _hasUsefulServing(
      FatSecretSearchFood food,
      ) {
    for (final serving in food.servings) {
      final text = _normalize(
        serving.description,
      );

      if (RegExp(r'\bcan\b').hasMatch(text) ||
          RegExp(r'\bbottle\b').hasMatch(text) ||
          RegExp(r'\btablespoon\b').hasMatch(text) ||
          RegExp(r'\btablespoons\b').hasMatch(text) ||
          RegExp(r'\btbsp\b').hasMatch(text) ||
          RegExp(r'\bbag\b').hasMatch(text) ||
          RegExp(r'\bpack\b').hasMatch(text) ||
          RegExp(r'\bpacket\b').hasMatch(text) ||
          RegExp(r'\bpackage\b').hasMatch(text) ||
          RegExp(r'\bbox\b').hasMatch(text) ||
          RegExp(r'\bboxes\b').hasMatch(text) ||
          RegExp(r'\bpouch\b').hasMatch(text)) {
        return true;
      }
    }

    return false;
  }

  static int _score({
    required String query,
    required FatSecretSearchFood food,
  }) {
    final normalizedQuery = _normalize(query);
    final normalizedName = _normalize(food.name);
    final normalizedBrand = _normalize(
      food.brandName ?? '',
    );

    final combinedText = normalizedBrand.isEmpty
        ? normalizedName
        : '$normalizedBrand $normalizedName';

    final queryTokens = _tokens(query);
    final candidateTokens = _tokens(
      combinedText,
    );

    var score = 0;

    if (normalizedBrand.isNotEmpty) {
      if (normalizedBrand == normalizedQuery) {
        score += 250;
      } else if (normalizedQuery.contains(normalizedBrand)) {
        score += 200;
      }
    }

    if (normalizedName == normalizedQuery) {
      score += 150;
    }

    if (combinedText == normalizedQuery) {
      score += 200;
    }

    if (normalizedName.contains(
      normalizedQuery,
    )) {
      score += 80;
    } else if (combinedText.contains(
      normalizedQuery,
    )) {
      score += 80;
    }

    for (final token in queryTokens) {
      if (candidateTokens.contains(token)) {
        score += 30;
      } else {
        score -= 50;

        if (_criticalVariants.contains(token)) {
          score -= 100;
        }
      }
    }

    for (final variant in _criticalVariants) {
      if (candidateTokens.contains(variant) &&
          !queryTokens.contains(variant)) {
        score -= 100;
      }
    }

    if (_hasUsefulServing(food)) {
      score += 5;
    }

    return score;
  }

  static List<FatSecretSearchFood> rank({
    required String query,
    required List<FatSecretSearchFood> foods,
  }) {
    if (foods.length <= 1) {
      return foods;
    }

    final ranked = foods.asMap().entries.map(
          (entry) {
        final score = _score(
          query: query,
          food: entry.value,
        );

        print(
          'RANK CANDIDATE | '
              'query="$query" | '
              'name="${entry.value.name}" | '
              'brand="${entry.value.brandName}" | '
              'score=$score | '
              'servings=${entry.value.servings.map((e) => e.description).toList()}',
        );

        return _RankedCandidate(
          food: entry.value,
          originalIndex: entry.key,
          score: score,
        );
      },
    ).toList();

    ranked.sort((a, b) {
      final scoreCompare =
      b.score.compareTo(a.score);

      if (scoreCompare != 0) {
        return scoreCompare;
      }

      return a.originalIndex.compareTo(
        b.originalIndex,
      );
    });

    print(
      'RANK WINNER | '
          'query="$query" | '
          'name="${ranked.first.food.name}" | '
          'brand="${ranked.first.food.brandName}" | '
          'score=${ranked.first.score}',
    );

    return ranked
        .map((candidate) => candidate.food)
        .toList();
  }
}

class _RankedCandidate {
  final FatSecretSearchFood food;
  final int originalIndex;
  final int score;

  const _RankedCandidate({
    required this.food,
    required this.originalIndex,
    required this.score,
  });
}