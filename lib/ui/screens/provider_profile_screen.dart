import 'package:flutter/material.dart';
import 'package:oficios/data/repositories/order_repository.dart';
import 'package:oficios/data/repositories/user_profile_repository.dart';
import 'package:oficios/models/order_request.dart';
import 'package:oficios/models/provider.dart';
import 'package:oficios/ui/screens/contact_success_screen.dart';
import 'package:oficios/ui/widgets/primary_button.dart';
import 'package:oficios/ui/widgets/provider_start.dart';

class ProviderProfileScreen extends StatelessWidget {
  final Provider provider;
  final OrderRepository orderRepository;
  final UserProfileRepository profileRepository;
  final int extraPhotosCount;

  const ProviderProfileScreen({
    super.key,
    required this.provider,
    required this.orderRepository,
    required this.profileRepository,
    this.extraPhotosCount = 12,
  });

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
                          value: provider.rating.toString(),
                          label: '${provider.reviews} opiniones',
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
                          _MorePhotosThumbnail(count: extraPhotosCount),
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
                  final profile = profileRepository.getProfile();
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
                    location: profile.location.isNotEmpty
                        ? profile.location
                        : provider.coverageZone,
                  );

                  try {
                    await orderRepository.createOrder(order);
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
