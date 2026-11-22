import 'package:oficios/data/database/app_database.dart';
import 'package:oficios/data/repositories/provider_review_repository.dart';
import 'package:oficios/models/provider_review.dart';

class SqliteProviderReviewRepository implements ProviderReviewRepository {
  SqliteProviderReviewRepository({AppDatabase? database})
    : _database = database ?? AppDatabase.instance;

  final AppDatabase _database;

  @override
  Future<ProviderReviewSummary> getReviews({
    required String providerId,
    required ProviderReviewSummary initialSummary,
  }) async {
    _validateProviderId(providerId);
    final database = await _database.database;
    final rows = await database.query(
      'provider_reviews',
      where: 'provider_id = ?',
      whereArgs: [providerId],
      orderBy: 'reviewed_at DESC, review_id DESC',
    );
    final persistedReviews = rows.map(_reviewFromRow).toList(growable: false);
    return initialSummary.withAdditionalReviews(persistedReviews);
  }

  @override
  Future<ProviderReviewSummary> addReview({
    required String providerId,
    required ProviderReview review,
    required ProviderReviewSummary initialSummary,
  }) async {
    _validateProviderId(providerId);
    if (review.rating < 1 || review.rating > 5) {
      throw ArgumentError('La calificación debe estar entre 1 y 5.');
    }

    final database = await _database.database;
    await database.insert('provider_reviews', {
      'provider_id': providerId,
      'review_id': review.id,
      'reviewer_name': review.reviewerName,
      'reviewed_at': review.date.toUtc().toIso8601String(),
      'rating': review.rating,
      'comment': review.comment,
    });

    return getReviews(providerId: providerId, initialSummary: initialSummary);
  }

  ProviderReview _reviewFromRow(Map<String, Object?> row) {
    return ProviderReview(
      id: row['review_id'] as String,
      reviewerName: row['reviewer_name'] as String,
      date: DateTime.parse(row['reviewed_at'] as String).toLocal(),
      rating: row['rating'] as int,
      comment: row['comment'] as String,
    );
  }

  void _validateProviderId(String providerId) {
    if (providerId.trim().isEmpty) {
      throw ArgumentError('El prestador debe tener un identificador.');
    }
  }
}
