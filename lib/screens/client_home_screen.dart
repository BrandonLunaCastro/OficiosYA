import 'package:flutter/material.dart';
import 'package:oficios/models/user_profile.dart';
import 'package:oficios/routes/app_routes.dart';
import 'package:oficios/widgets/app_bottom_nav.dart';
import 'package:oficios/widgets/category_item.dart';
import 'package:oficios/widgets/home_top_bar.dart';
import 'package:oficios/widgets/provider_card.dart';
import 'package:oficios/widgets/search_bar_field.dart';
import 'package:oficios/widgets/urgency_banner.dart';

class ClientHomeScreen extends StatefulWidget {
  const ClientHomeScreen({super.key});

  @override
  State<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    final profile = UserProfile.instance;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            HomeTopBar(
              location: profile.location,
              initials: profile.initials,
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.editProfileClient),
            ),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SearchBarField(),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Categorías populares',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Ver todo'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        CategoryItem(icon: Icons.plumbing, label: 'Plomería'),
                        CategoryItem(
                          icon: Icons.electrical_services,
                          label: 'Electricidad',
                        ),
                        CategoryItem(
                          icon: Icons.water_drop_outlined,
                          label: 'Limpieza',
                        ),
                        CategoryItem(
                          icon: Icons.format_paint_outlined,
                          label: 'Pintura',
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const UrgencyBanner(),
                    const SizedBox(height: 24),
                    const Text(
                      'Oficios destacados cerca tuyo',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const ProviderCard(
                      initials: 'CR',
                      name: 'Carlos Rodriguez',
                      specialty: 'Plomero verificado',
                      rating: 4.8,
                      reviews: 45,
                      distanceKm: 1.5,
                      jobsCount: 120,
                    ),
                    const ProviderCard(
                      initials: 'JL',
                      name: 'Jorge López',
                      specialty: 'Electricista verificado',
                      rating: 4.9,
                      reviews: 32,
                      distanceKm: 2.2,
                      jobsCount: 94,
                    ),
                    const ProviderCard(
                      initials: 'MG',
                      name: 'Martín Gómez',
                      specialty: 'Pintor verificado',
                      rating: 4.6,
                      reviews: 18,
                      distanceKm: 3.1,
                      jobsCount: 50,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _navIndex,
        onTap: (index) => setState(() => _navIndex = index),
      ),
    );
  }
}
