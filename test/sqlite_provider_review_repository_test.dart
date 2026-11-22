import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:oficios/data/database/app_database.dart';
import 'package:oficios/data/repositories/sqlite_provider_review_repository.dart';
import 'package:oficios/models/provider_review.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test('persists comments and recalculates ratings per provider', () async {
    final directory = await Directory.systemTemp.createTemp(
      'oficios_provider_reviews_',
    );
    addTearDown(() async {
      if (await directory.exists()) {
        await directory.delete(recursive: true);
      }
    });
    final databasePath = path.join(directory.path, 'reviews.db');
    final firstDatabase = AppDatabase(databasePath: databasePath);
    addTearDown(firstDatabase.close);
    final firstRepository = SqliteProviderReviewRepository(
      database: firstDatabase,
    );
    const initialSummary = ProviderReviewSummary(
      averageRating: 4.8,
      totalReviews: 45,
      ratingCounts: {5: 36, 4: 9},
      reviews: [],
    );
    final review = ProviderReview(
      id: 'review-persisted',
      reviewerName: 'Ana Gómez',
      date: DateTime(2026, 11, 21),
      rating: 5,
      comment: 'Excelente atención y muy puntual.',
    );

    final updatedSummary = await firstRepository.addReview(
      providerId: 'provider-one',
      review: review,
      initialSummary: initialSummary,
    );
    expect(updatedSummary.totalReviews, 46);
    expect(updatedSummary.averageRating, closeTo(4.804347826, 0.000001));
    expect(updatedSummary.reviews.single.comment, review.comment);
    await firstDatabase.close();

    final reopenedDatabase = AppDatabase(databasePath: databasePath);
    addTearDown(reopenedDatabase.close);
    final reopenedRepository = SqliteProviderReviewRepository(
      database: reopenedDatabase,
    );
    final persistedSummary = await reopenedRepository.getReviews(
      providerId: 'provider-one',
      initialSummary: initialSummary,
    );
    final otherProviderSummary = await reopenedRepository.getReviews(
      providerId: 'provider-two',
      initialSummary: initialSummary,
    );

    expect(persistedSummary.totalReviews, 46);
    expect(persistedSummary.averageRating, updatedSummary.averageRating);
    expect(persistedSummary.reviews.single.comment, review.comment);
    expect(otherProviderSummary.totalReviews, 45);
    expect(otherProviderSummary.reviews, isEmpty);
  });
}
