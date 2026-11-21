import 'package:oficios/models/provider_review.dart';

abstract interface class ProviderReviewRepository {
  Future<ProviderReviewSummary> getReviews();

  Future<ProviderReviewSummary> addReview(ProviderReview review);
}
