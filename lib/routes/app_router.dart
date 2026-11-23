import 'package:flutter/material.dart';
import 'package:oficios/data/database/app_database.dart';
import 'package:oficios/data/repositories/sqlite_order_repository.dart';
import 'package:oficios/data/repositories/sqlite_user_profile_repository.dart';
import 'package:oficios/data/repositories/mock_onboarding_repository.dart';
import 'package:oficios/data/repositories/mock_provider_repository.dart';
import 'package:oficios/data/repositories/mock_provider_service_repository.dart';
import 'package:oficios/data/repositories/sqlite_professional_profile_repository.dart';
import 'package:oficios/data/repositories/sqlite_provider_contact_repository.dart';
import 'package:oficios/data/repositories/sqlite_auth_repository.dart';
import 'package:oficios/data/repositories/sqlite_provider_review_repository.dart';
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
import 'package:oficios/ui/screens/provider_orders_screen.dart';
import 'package:oficios/ui/screens/provider_reviews_screen.dart';
import 'package:oficios/ui/screens/register_screen.dart';
import 'package:oficios/ui/screens/splash_screen.dart';
import 'package:oficios/routes/app_routes.dart';

class AppRouter {
  static const String splash = 'splash';
  static const String onboarding = 'onboarding';
  static final providerProfileRepository =
      SqliteProfessionalProfileRepository();
  static final providerServiceRepository = MockProviderServiceRepository();
  static final providerContactRepository = SqliteProviderContactRepository();
  static final authRepository = SqliteAuthRepository.instance;
  static final clientProfileRepository = SqliteUserProfileRepository();
  static final orderRepository = SqliteOrderRepository();
  static final providerReviewRepository = SqliteProviderReviewRepository();
  static final providerRepository = MockProviderRepository(
    professionalProfileRepository: providerProfileRepository,
    providerContactRepository: providerContactRepository,
    database: AppDatabase.instance,
  );

  static final Map<String, WidgetBuilder> routes = {
    AppRoutes.splash: (context) => const SplashScreen(),
    AppRoutes.onboarding: (context) => const OnboardingScreen(
      onboardingRepository: MockOnboardingRepository(),
    ),
    AppRoutes.login: (context) => Login(
      authRepository: authRepository,
      clientProfileRepository: clientProfileRepository,
      professionalProfileRepository: providerProfileRepository,
      providerContactRepository: providerContactRepository,
    ),
    AppRoutes.register: (context) =>
        Register(registrationRepository: authRepository),
    AppRoutes.chooseRole: (context) => const HomeScreen(),
    AppRoutes.editProfileClient: (context) =>
        EditProfileClientScreen(profileRepository: clientProfileRepository),
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
    AppRoutes.providerOrders: (context) => ProviderOrdersScreen(
      orderRepository: orderRepository,
      profileRepository: providerProfileRepository,
    ),
    AppRoutes.providerReviews: (context) => ProviderReviewsScreen(
      reviewRepository: providerReviewRepository,
      profileRepository: providerProfileRepository,
    ),
    AppRoutes.clientHome: (context) => ClientHomeScreen(
      profileRepository: clientProfileRepository,
      providerRepository: providerRepository,
      orderRepository: orderRepository,
      reviewRepository: providerReviewRepository,
    ),
    AppRoutes.orders: (context) =>
        OrdersScreen(orderRepository: orderRepository),
  };
}
