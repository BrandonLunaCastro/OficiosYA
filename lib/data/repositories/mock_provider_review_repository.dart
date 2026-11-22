import 'package:oficios/data/repositories/provider_review_repository.dart';
import 'package:oficios/models/provider_review.dart';

class MockProviderReviewRepository implements ProviderReviewRepository {
  const MockProviderReviewRepository();

  static final instance = MockProviderReviewRepository();

  static final Map<String, List<ProviderReview>> _reviewsByProvider = {};

  @override
  Future<ProviderReviewSummary> getReviews({
    required String providerId,
    required ProviderReviewSummary initialSummary,
  }) async {
    return initialSummary.withAdditionalReviews(
      List<ProviderReview>.unmodifiable(
        _reviewsByProvider[providerId] ?? const [],
      ),
    );
  }

  @override
  Future<ProviderReviewSummary> addReview({
    required String providerId,
    required ProviderReview review,
    required ProviderReviewSummary initialSummary,
  }) async {
    if (providerId.trim().isEmpty) {
      throw ArgumentError('El prestador debe tener un identificador.');
    }
    if (review.rating < 1 || review.rating > 5) {
      throw ArgumentError('La calificación debe estar entre 1 y 5.');
    }

    _reviewsByProvider.putIfAbsent(providerId, () => []).insert(0, review);
    return getReviews(providerId: providerId, initialSummary: initialSummary);
  }
}
