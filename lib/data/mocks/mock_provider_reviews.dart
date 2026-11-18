import 'package:oficios/models/provider_review.dart';

final mockProviderReviewSummary = ProviderReviewSummary(
  averageRating: 4.8,
  totalReviews: 45,
  ratingCounts: {5: 36, 4: 9, 3: 0, 2: 0, 1: 0},
  reviews: [
    ProviderReview(
      id: 'resena-001',
      reviewerName: 'Lucía Martínez',
      date: DateTime(2026, 11, 12),
      rating: 5,
      comment: 'Muy puntual y prolijo. Solucionó la pérdida de agua y dejó todo funcionando. ¡Lo recomiendo!',
    ),
    ProviderReview(
      id: 'resena-002',
      reviewerName: 'Diego Fernández',
      date: DateTime(2026, 11, 8),
      rating: 4,
      comment: 'Buen trabajo con la instalación. Me explicó todo y respetó lo acordado.',
    ),
  ],
);
