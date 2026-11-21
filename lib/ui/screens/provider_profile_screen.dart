import 'package:flutter/material.dart';
import 'package:oficios/data/repositories/order_repository.dart';
import 'package:oficios/data/repositories/provider_review_repository.dart';
import 'package:oficios/data/repositories/mock_provider_review_repository.dart';
import 'package:oficios/data/repositories/user_profile_repository.dart';
import 'package:oficios/models/order_request.dart';
import 'package:oficios/models/provider.dart';
import 'package:oficios/models/provider_review.dart';
import 'package:oficios/ui/screens/contact_success_screen.dart';
import 'package:oficios/ui/widgets/primary_button.dart';
import 'package:oficios/ui/widgets/provider_start.dart';

class ProviderProfileScreen extends StatefulWidget {
  final Provider provider;
  final OrderRepository orderRepository;
  final UserProfileRepository profileRepository;
  final ProviderReviewRepository reviewRepository;
  final int extraPhotosCount;

  const ProviderProfileScreen({
    super.key,
    required this.provider,
    required this.orderRepository,
    required this.profileRepository,
    this.reviewRepository = const MockProviderReviewRepository(),
    this.extraPhotosCount = 12,
  });

  @override
  State<ProviderProfileScreen> createState() => _ProviderProfileScreenState();
}

class _ProviderProfileScreenState extends State<ProviderProfileScreen> {
  late double _averageRating;
  late int _totalReviews;

  Provider get provider => widget.provider;

  @override
  void initState() {
    super.initState();
    _averageRating = provider.rating;
    _totalReviews = provider.reviews;
  }

  Future<void> _showRatingDialog() async {
    final result = await showDialog<_RatingFormResult>(
      context: context,
      builder: (dialogContext) => _RatingDialog(providerName: provider.name),
    );

    if (result == null) return;

    final profile = widget.profileRepository.getProfile();
    final reviewerName = profile.name.trim().isEmpty
        ? 'Cliente'
        : profile.name.trim();

    try {
      final summary = await widget.reviewRepository.addReview(
        ProviderReview(
          id: 'resena-${DateTime.now().microsecondsSinceEpoch}',
          reviewerName: reviewerName,
          date: DateTime.now(),
          rating: result.rating,
          comment: result.comment.trim().isEmpty
              ? 'Servicio calificado sin comentario.'
              : result.comment.trim(),
        ),
      );

      if (!mounted) return;
      setState(() {
        _averageRating = summary.averageRating;
        _totalReviews = summary.totalReviews;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Calificación registrada')));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo guardar la calificación: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF2B66DF);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(icon: const Icon(Icons.ios_share), onPressed: () {}),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: primaryColor,
                      child: Text(
                        provider.initials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      provider.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green.shade700,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            provider.specialty,
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ProviderStat(
                          icon: Icons.star,
                          iconColor: Colors.amber,
                          value: _averageRating.toStringAsFixed(1),
                          label: '$_totalReviews opiniones',
                        ),
                        ProviderStat(
                          icon: Icons.location_on_outlined,
                          iconColor: primaryColor,
                          value: '${provider.distanceKm}km',
                          label: 'Distancia',
                        ),
                        ProviderStat(
                          icon: Icons.work_outline,
                          iconColor: primaryColor,
                          value: provider.jobsCount.toString(),
                          label: 'Trabajos exitosos',
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: _showRatingDialog,
                      icon: const Icon(Icons.star_outline),
                      label: const Text('Calificar prestador'),
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 12),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Sobre mí',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        provider.aboutMe.isEmpty
                            ? 'Este prestador todavía no agregó una descripción.'
                            : provider.aboutMe,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Trabajos recientes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 80,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _JobThumbnail(),
                          const SizedBox(width: 10),
                          _JobThumbnail(),
                          const SizedBox(width: 10),
                          _MorePhotosThumbnail(count: widget.extraPhotosCount),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: PrimaryButton(
                text: 'Solicitar presupuesto directo →',
                onPressed: () async {
                  final profile = widget.profileRepository.getProfile();
                  final now = DateTime.now();
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
                  final order = OrderRequest(
                    service: provider.specialty,
                    providerInitials: provider.initials,
                    providerName: provider.name,
                    date: '${now.day} ${months[now.month - 1]}',
                    time:
                        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
                    phone: provider.phone,
                    email: provider.email,
                    clientName: profile.name,
                    clientPhone: profile.phone,
                    clientEmail: profile.email,
                    location: profile.location.isNotEmpty
                        ? profile.location
                        : provider.coverageZone,
                  );

                  try {
                    await widget.orderRepository.createOrder(order);
                    if (!context.mounted) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ContactSuccessScreen(provider: provider),
                      ),
                    );
                  } catch (error) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('No se pudo registrar el pedido: $error'),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _JobThumbnail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(Icons.image_outlined, color: Colors.grey.shade500),
    );
  }
}

class _MorePhotosThumbnail extends StatelessWidget {
  final int count;

  const _MorePhotosThumbnail({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          '+$count fotos',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _RatingFormResult {
  const _RatingFormResult({required this.rating, required this.comment});

  final int rating;
  final String comment;
}

class _RatingDialog extends StatefulWidget {
  const _RatingDialog({required this.providerName});

  final String providerName;

  @override
  State<_RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<_RatingDialog> {
  int _selectedRating = 0;
  late final TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      titlePadding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
      contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
      actionsPadding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF4DC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.star_rounded, color: Color(0xFFDAA520)),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Calificar prestador',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.providerName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '¿Cómo fue tu experiencia?',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.blueGrey, fontSize: 12),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBF2),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFF1E4C2)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    final star = index + 1;
                    return IconButton(
                      tooltip: '$star estrella${star == 1 ? '' : 's'}',
                      onPressed: () => setState(() => _selectedRating = star),
                      icon: Icon(
                        star <= _selectedRating
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        color: const Color(0xFFDAA520),
                        size: 36,
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _commentController,
                maxLines: 4,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: 'Comentario',
                  hintText: 'Contá cómo fue el servicio',
                  prefixIcon: const Icon(Icons.rate_review_outlined, size: 20),
                  filled: true,
                  fillColor: const Color(0xFFF8F9FC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE3E7EF)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _selectedRating == 0
              ? null
              : () {
                  Navigator.pop(
                    context,
                    _RatingFormResult(
                      rating: _selectedRating,
                      comment: _commentController.text,
                    ),
                  );
                },
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
