import 'package:oficios/models/provider_review.dart';

abstract interface class ProviderReviewRepository {
  Future<ProviderReviewSummary> getReviews({
    required String providerId,
    required ProviderReviewSummary initialSummary,
  });

  Future<ProviderReviewSummary> addReview({
    required String providerId,
    required ProviderReview review,
    required ProviderReviewSummary initialSummary,
  });
}
