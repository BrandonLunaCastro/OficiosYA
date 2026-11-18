import 'package:oficios/data/mocks/mock_provider_reviews.dart';
import 'package:oficios/data/repositories/provider_review_repository.dart';
import 'package:oficios/models/provider_review.dart';

class MockProviderReviewRepository implements ProviderReviewRepository {
  const MockProviderReviewRepository();

  @override
  Future<ProviderReviewSummary> getReviews() async => mockProviderReviewSummary;
}
