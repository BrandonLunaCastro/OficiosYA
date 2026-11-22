class ProviderReview {
  final String id;
  final String reviewerName;
  final DateTime date;
  final int rating;
  final String comment;

  const ProviderReview({
    required this.id,
    required this.reviewerName,
    required this.date,
    required this.rating,
    required this.comment,
  });
}

class ProviderReviewSummary {
  final double averageRating;
  final int totalReviews;
  final Map<int, int> ratingCounts;
  final List<ProviderReview> reviews;

  const ProviderReviewSummary({
    required this.averageRating,
    required this.totalReviews,
    required this.ratingCounts,
    required this.reviews,
  });

  factory ProviderReviewSummary.fromProviderStats({
    required double averageRating,
    required int totalReviews,
    List<ProviderReview> reviews = const [],
  }) {
    if (totalReviews <= 0) {
      return ProviderReviewSummary(
        averageRating: 0,
        totalReviews: 0,
        ratingCounts: const {},
        reviews: reviews,
      );
    }

    final lowerRating = averageRating.floor().clamp(1, 5);
    final upperRating = averageRating.ceil().clamp(1, 5);
    final upperCount = lowerRating == upperRating
        ? 0
        : ((averageRating - lowerRating) * totalReviews).round().clamp(
            0,
            totalReviews,
          );
    final ratingCounts = <int, int>{lowerRating: totalReviews - upperCount};
    if (upperCount > 0) {
      ratingCounts[upperRating] = upperCount;
    }

    return ProviderReviewSummary(
      averageRating: averageRating,
      totalReviews: totalReviews,
      ratingCounts: ratingCounts,
      reviews: reviews,
    );
  }

  int countForRating(int rating) => ratingCounts[rating] ?? 0;

  String get displayRating {
    final oneDecimal = averageRating.toStringAsFixed(1);
    if ((double.parse(oneDecimal) - averageRating).abs() < 0.0005) {
      return oneDecimal;
    }
    return averageRating.toStringAsFixed(3);
  }

  ProviderReviewSummary withAdditionalReviews(
    List<ProviderReview> additionalReviews,
  ) {
    if (additionalReviews.isEmpty) return this;

    final counts = Map<int, int>.from(ratingCounts);
    var ratingTotal = averageRating * totalReviews;
    for (final review in additionalReviews) {
      ratingTotal += review.rating;
      counts[review.rating] = (counts[review.rating] ?? 0) + 1;
    }

    final combinedReviews = [...additionalReviews, ...reviews]
      ..sort((first, second) => second.date.compareTo(first.date));
    final combinedTotal = totalReviews + additionalReviews.length;

    return ProviderReviewSummary(
      averageRating: ratingTotal / combinedTotal,
      totalReviews: combinedTotal,
      ratingCounts: counts,
      reviews: combinedReviews,
    );
  }
}
