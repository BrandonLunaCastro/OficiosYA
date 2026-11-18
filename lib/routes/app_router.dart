import 'package:flutter/material.dart';
import 'package:oficios/data/repositories/in_memory_user_profile_repository.dart';
import 'package:oficios/data/repositories/in_memory_order_repository.dart';
import 'package:oficios/data/repositories/mock_onboarding_repository.dart';
import 'package:oficios/data/repositories/mock_provider_contact_repository.dart';
import 'package:oficios/data/repositories/mock_provider_repository.dart';
import 'package:oficios/data/repositories/mock_provider_service_repository.dart';
import 'package:oficios/data/repositories/mock_professional_profile_repository.dart';
import 'package:oficios/data/repositories/mock_provider_review_repository.dart';
import 'package:oficios/ui/screens/client_home_screen.dart';
import 'package:oficios/ui/screens/edit_profile_client_screen.dart';
import 'package:oficios/ui/screens/edit_profile_professional_screen.dart';
import 'package:oficios/ui/screens/home_screen.dart';
import 'package:oficios/ui/screens/login_screen.dart';
import 'package:oficios/ui/screens/onboarding_screen.dart';
import 'package:oficios/ui/screens/orders_screen.dart';
import 'package:oficios/ui/screens/professional_profile_screen.dart';
import 'package:oficios/ui/screens/provider_services_screen.dart';
import 'package:oficios/ui/screens/provider_contact_screen.dart';
import 'package:oficios/ui/screens/provider_reviews_screen.dart';
import 'package:oficios/ui/screens/register_screen.dart';
import 'package:oficios/ui/screens/splash_screen.dart';
import 'package:oficios/routes/app_routes.dart';

class AppRouter {
  static const String splash = 'splash';
  static const String onboarding = 'onboarding';
  static final providerProfileRepository = MockProfessionalProfileRepository();
  static final providerServiceRepository = MockProviderServiceRepository();
  static final providerContactRepository = MockProviderContactRepository();
  static const providerReviewRepository = MockProviderReviewRepository();

  static final Map<String, WidgetBuilder> routes = {
    AppRoutes.splash: (context) => const SplashScreen(),
    AppRoutes.onboarding: (context) => const OnboardingScreen(
      onboardingRepository: MockOnboardingRepository(),
    ),
    AppRoutes.login: (context) => const Login(),
    AppRoutes.register: (context) => const Register(),
    AppRoutes.chooseRole: (context) => const HomeScreen(),
    AppRoutes.editProfileClient: (context) => EditProfileClientScreen(
      profileRepository: InMemoryUserProfileRepository.instance,
    ),
    AppRoutes.editProfileProfessional: (context) =>
        EditProfileProfessionalScreen(
          profileRepository: providerProfileRepository,
          contactRepository: providerContactRepository,
        ),
    AppRoutes.createProfileProfessional: (context) =>
        EditProfileProfessionalScreen(
          profileRepository: providerProfileRepository,
          contactRepository: providerContactRepository,
          isInitialSetup: true,
        ),
    AppRoutes.professionalProfile: (context) => ProfessionalProfileScreen(
      profileRepository: providerProfileRepository,
      serviceRepository: providerServiceRepository,
      contactRepository: providerContactRepository,
    ),
    AppRoutes.providerServices: (context) =>
        ProviderServicesScreen(serviceRepository: providerServiceRepository),
    AppRoutes.providerContact: (context) =>
        ProviderContactScreen(contactRepository: providerContactRepository),
    AppRoutes.providerReviews: (context) =>
        const ProviderReviewsScreen(reviewRepository: providerReviewRepository),
    AppRoutes.clientHome: (context) => ClientHomeScreen(
      profileRepository: InMemoryUserProfileRepository.instance,
      providerRepository: const MockProviderRepository(),
      orderRepository: InMemoryOrderRepository.instance,
    ),
    AppRoutes.orders: (context) =>
        OrdersScreen(orderRepository: InMemoryOrderRepository.instance),
  };
}
