import 'package:flutter_test/flutter_test.dart';
import 'package:oficios/data/repositories/mock_provider_review_repository.dart';

void main() {
  test('loads mock rating summary and recent reviews', () async {
    const repository = MockProviderReviewRepository();

    final summary = await repository.getReviews();

    expect(summary.averageRating, 4.8);
    expect(summary.totalReviews, 45);
    expect(summary.countForRating(5), 36);
    expect(summary.countForRating(4), 9);
    expect(summary.reviews, hasLength(2));
    expect(summary.reviews.first.reviewerName, 'Lucía Martínez');
    expect(summary.reviews.first.rating, 5);
  });
}
