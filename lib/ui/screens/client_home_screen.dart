import 'package:flutter/material.dart';
import 'package:oficios/data/repositories/order_repository.dart';
import 'package:oficios/data/repositories/provider_repository.dart';
import 'package:oficios/data/repositories/provider_review_repository.dart';
import 'package:oficios/data/repositories/user_profile_repository.dart';
import 'package:oficios/models/provider.dart';
import 'package:oficios/routes/app_routes.dart';
import 'package:oficios/ui/screens/provider_profile_screen.dart';
import 'package:oficios/ui/screens/search_results_screen.dart';
import 'package:oficios/ui/widgets/app_bottom_nav.dart';
import 'package:oficios/ui/widgets/category_item.dart';
import 'package:oficios/ui/widgets/home_top_bar.dart';
import 'package:oficios/ui/widgets/provider_card.dart';
import 'package:oficios/ui/widgets/search_bar_field.dart';
import 'package:oficios/ui/widgets/urgency_banner.dart';

class ClientHomeScreen extends StatefulWidget {
  const ClientHomeScreen({
    super.key,
    required this.profileRepository,
    required this.providerRepository,
    required this.orderRepository,
    required this.reviewRepository,
  });

  final UserProfileRepository profileRepository;
  final ProviderRepository providerRepository;
  final OrderRepository orderRepository;
  final ProviderReviewRepository reviewRepository;

  @override
  State<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  int _navIndex = 0;
  late final Future<List<Provider>> _providersFuture;

  @override
  void initState() {
    super.initState();
    _providersFuture = widget.providerRepository.getProviders();
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.profileRepository.getProfile();

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
                    SearchBarField(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchResultsScreen(
                              providerRepository: widget.providerRepository,
                              orderRepository: widget.orderRepository,
                              reviewRepository: widget.reviewRepository,
                              profileRepository: widget.profileRepository,
                            ),
                          ),
                        );
                      },
                    ),
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
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _categoryItem(Icons.plumbing, 'Plomería'),
                          _categoryItem(
                            Icons.electrical_services,
                            'Electricidad',
                          ),
                          _categoryItem(Icons.build_outlined, 'Mecánica'),
                          _categoryItem(Icons.format_paint_outlined, 'Pintura'),
                          _categoryItem(Icons.local_fire_department, 'Gas'),
                        ],
                      ),
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
                    FutureBuilder<List<Provider>>(
                      future: _providersFuture,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Text(
                            'No se pudieron cargar los prestadores.',
                          );
                        }
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Column(
                          children: snapshot.data!
                              .map(
                                (provider) => ProviderCard(
                                  provider: provider,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProviderProfileScreen(
                                              provider: provider,
                                              orderRepository:
                                                  widget.orderRepository,
                                              reviewRepository:
                                                  widget.reviewRepository,
                                              profileRepository:
                                                  widget.profileRepository,
                                            ),
                                      ),
                                    );
                                  },
                                ),
                              )
                              .toList(),
                        );
                      },
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
        onTap: (index) {
          setState(() => _navIndex = index);
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchResultsScreen(
                  providerRepository: widget.providerRepository,
                  orderRepository: widget.orderRepository,
                  reviewRepository: widget.reviewRepository,
                  profileRepository: widget.profileRepository,
                ),
              ),
            );
          } else if (index == 2) {
            Navigator.pushNamed(context, AppRoutes.orders);
          } else if (index == 3) {
            Navigator.pushNamed(context, AppRoutes.editProfileClient);
          }
        },
      ),
    );
  }

  Widget _categoryItem(IconData icon, String category) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: CategoryItem(
        icon: icon,
        label: category,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchResultsScreen(
                providerRepository: widget.providerRepository,
                orderRepository: widget.orderRepository,
                reviewRepository: widget.reviewRepository,
                profileRepository: widget.profileRepository,
                initialCategory: category,
              ),
            ),
          );
        },
      ),
    );
  }
}
