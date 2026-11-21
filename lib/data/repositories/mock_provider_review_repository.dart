import 'package:oficios/data/mocks/mock_provider_reviews.dart';
import 'package:oficios/data/repositories/provider_review_repository.dart';
import 'package:oficios/models/provider_review.dart';

class MockProviderReviewRepository implements ProviderReviewRepository {
  const MockProviderReviewRepository();

  static final instance = MockProviderReviewRepository();

  static ProviderReviewSummary _summary = mockProviderReviewSummary;

  @override
  Future<ProviderReviewSummary> getReviews() async => _summary;

  @override
  Future<ProviderReviewSummary> addReview(ProviderReview review) async {
    if (review.rating < 1 || review.rating > 5) {
      throw ArgumentError('La calificación debe estar entre 1 y 5.');
    }

    final reviews = [review, ..._summary.reviews];
    final ratingCounts = Map<int, int>.from(_summary.ratingCounts);
    ratingCounts[review.rating] = (ratingCounts[review.rating] ?? 0) + 1;

    final totalReviews = _summary.totalReviews + 1;
    final averageRating =
        ((_summary.averageRating * _summary.totalReviews) + review.rating) /
        totalReviews;

    _summary = ProviderReviewSummary(
      averageRating: averageRating,
      totalReviews: totalReviews,
      ratingCounts: ratingCounts,
      reviews: reviews,
    );
    return _summary;
  }
}
