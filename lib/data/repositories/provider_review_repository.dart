import 'package:oficios/models/provider_review.dart';

abstract interface class ProviderReviewRepository {
  Future<ProviderReviewSummary> getReviews();
}
