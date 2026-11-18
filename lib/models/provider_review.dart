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

  int countForRating(int rating) => ratingCounts[rating] ?? 0;
}
