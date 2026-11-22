import 'package:flutter_test/flutter_test.dart';
import 'package:oficios/data/mocks/mock_provider_reviews.dart';
import 'package:oficios/data/repositories/mock_provider_review_repository.dart';
import 'package:oficios/models/provider_review.dart';

void main() {
  test('loads mock rating summary and recent reviews', () async {
    const repository = MockProviderReviewRepository();

    final summary = await repository.getReviews(
      providerId: 'test-provider',
      initialSummary: mockProviderReviewSummary,
    );

    expect(summary.averageRating, 4.8);
    expect(summary.totalReviews, 45);
    expect(summary.countForRating(5), 36);
    expect(summary.countForRating(4), 9);
    expect(summary.reviews, hasLength(2));
    expect(summary.reviews.first.reviewerName, 'Lucía Martínez');
    expect(summary.reviews.first.rating, 5);
  });

  test('adds a rating and updates the summary', () async {
    final repository = MockProviderReviewRepository.instance;

    final summary = await repository.addReview(
      providerId: 'test-provider-with-new-review',
      initialSummary: mockProviderReviewSummary,
      review: ProviderReview(
        id: 'resena-test',
        reviewerName: 'Cliente de prueba',
        date: DateTime(2026, 11, 21),
        rating: 5,
        comment: 'Excelente servicio.',
      ),
    );

    expect(summary.totalReviews, 46);
    expect(summary.countForRating(5), 37);
    expect(summary.reviews.first.reviewerName, 'Cliente de prueba');
  });
}
