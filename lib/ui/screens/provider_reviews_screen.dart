import 'package:flutter/material.dart';
import 'package:oficios/data/repositories/provider_review_repository.dart';
import 'package:oficios/models/provider_review.dart';
import 'package:oficios/routes/app_routes.dart';
import 'package:oficios/ui/widgets/provider_bottom_nav.dart';

class ProviderReviewsScreen extends StatefulWidget {
  const ProviderReviewsScreen({super.key, required this.reviewRepository});

  final ProviderReviewRepository reviewRepository;

  @override
  State<ProviderReviewsScreen> createState() => _ProviderReviewsScreenState();
}

class _ProviderReviewsScreenState extends State<ProviderReviewsScreen> {
  static const _backgroundColor = Color(0xFFF4F6FA);
  static const _primaryColor = Color(0xFF2B66DF);
  static const _starColor = Color(0xFFAA6C1D);

  late final Future<ProviderReviewSummary> _reviewsFuture;
  _ReviewSortOrder _sortOrder = _ReviewSortOrder.recent;

  @override
  void initState() {
    super.initState();
    _reviewsFuture = widget.reviewRepository.getReviews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 64,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: Colors.white,
              child: const Text(
                'Valoraciones',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: FutureBuilder<ProviderReviewSummary>(
                future: _reviewsFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('No se pudieron cargar las valoraciones.'),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return _ReviewsContent(
                    summary: snapshot.data!,
                    sortOrder: _sortOrder,
                    onSortChanged: (sortOrder) =>
                        setState(() => _sortOrder = sortOrder),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ProviderBottomNav(
        currentIndex: 3,
        onTap: _handleNavigation,
      ),
    );
  }

  void _handleNavigation(int index) {
    final route = switch (index) {
      0 => AppRoutes.professionalProfile,
      1 => AppRoutes.providerServices,
      2 => AppRoutes.providerContact,
      _ => null,
    };
    if (route != null) {
      Navigator.pushNamed(context, route);
    }
  }
}

enum _ReviewSortOrder { recent, highestRated }

class _ReviewsContent extends StatelessWidget {
  const _ReviewsContent({
    required this.summary,
    required this.sortOrder,
    required this.onSortChanged,
  });

  final ProviderReviewSummary summary;
  final _ReviewSortOrder sortOrder;
  final ValueChanged<_ReviewSortOrder> onSortChanged;

  @override
  Widget build(BuildContext context) {
    final reviews = [...summary.reviews];
    reviews.sort((first, second) {
      if (sortOrder == _ReviewSortOrder.highestRated) {
        final ratingOrder = second.rating.compareTo(first.rating);
        if (ratingOrder != 0) return ratingOrder;
      }
      return second.date.compareTo(first.date);
    });

    final maxRatingCount = summary.ratingCounts.values.fold<int>(
      0,
      (largest, count) => count > largest ? count : largest,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SummaryCard(summary: summary, maxRatingCount: maxRatingCount),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Reseñas recibidas',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              PopupMenuButton<_ReviewSortOrder>(
                initialValue: sortOrder,
                onSelected: onSortChanged,
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: _ReviewSortOrder.recent,
                    child: Text('Más recientes'),
                  ),
                  PopupMenuItem(
                    value: _ReviewSortOrder.highestRated,
                    child: Text('Mejor valoradas'),
                  ),
                ],
                child: Text(
                  sortOrder == _ReviewSortOrder.recent
                      ? 'Más recientes'
                      : 'Mejor valoradas',
                  style: const TextStyle(
                    color: _ProviderReviewsScreenState._primaryColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (final review in reviews) ...[
            _ReviewCard(review: review),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.summary, required this.maxRatingCount});

  final ProviderReviewSummary summary;
  final int maxRatingCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE7EAF0)),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                summary.averageRating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _Stars(rating: 5, size: 15),
                    const SizedBox(height: 2),
                    Text(
                      '${summary.totalReviews} opiniones de clientes',
                      style: TextStyle(
                        color: Colors.blueGrey.shade400,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (var rating = 5; rating >= 1; rating--)
            _RatingDistributionRow(
              rating: rating,
              count: summary.countForRating(rating),
              maxCount: maxRatingCount,
            ),
        ],
      ),
    );
  }
}

class _RatingDistributionRow extends StatelessWidget {
  const _RatingDistributionRow({
    required this.rating,
    required this.count,
    required this.maxCount,
  });

  final int rating;
  final int count;
  final int maxCount;

  @override
  Widget build(BuildContext context) {
    final widthFactor = maxCount == 0 ? 0.0 : count / maxCount;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 14,
            child: Text('$rating', style: const TextStyle(fontSize: 9)),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: 5,
                child: Stack(
                  children: [
                    const Positioned.fill(
                      child: ColoredBox(color: Color(0xFFE4E8ED)),
                    ),
                    FractionallySizedBox(
                      widthFactor: widthFactor,
                      child: const ColoredBox(
                        color: _ProviderReviewsScreenState._primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: 26,
            child: Text(
              '$count',
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 9),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review});

  final ProviderReview review;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE7EAF0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  review.reviewerName,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                _formatDate(review.date),
                style: TextStyle(color: Colors.blueGrey.shade400, fontSize: 9),
              ),
            ],
          ),
          const SizedBox(height: 4),
          _Stars(rating: review.rating, size: 15),
          const SizedBox(height: 4),
          Text(
            review.comment,
            style: TextStyle(
              color: Colors.blueGrey.shade500,
              fontSize: 11,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'ene',
      'feb',
      'mar',
      'abr',
      'may',
      'jun',
      'jul',
      'ago',
      'sep',
      'oct',
      'nov',
      'dic',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

class _Stars extends StatelessWidget {
  const _Stars({required this.rating, required this.size});

  final int rating;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (index) => Icon(
          Icons.star_border,
          color: index < rating
              ? _ProviderReviewsScreenState._starColor
              : Colors.blueGrey.shade300,
          size: size,
        ),
      ),
    );
  }
}
