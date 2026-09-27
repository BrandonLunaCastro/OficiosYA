import 'package:flutter/material.dart';
import 'package:oficios/screens/client_home_screen.dart';
import 'package:oficios/screens/login_screen.dart';
import 'package:oficios/screens/register_screen.dart';
import 'package:oficios/screens/home_screen.dart';
import 'package:oficios/screens/edit_profile_client_screen.dart';
import 'package:oficios/screens/edit_profile_professional_screen.dart';
import 'package:oficios/screens/splash_screen.dart';
import 'package:oficios/screens/onboarding_screen.dart';
import 'package:oficios/screens/orders_screen.dart';
import 'app_routes.dart';

class AppRouter {
  static const String splash = 'splash';
  static const String onboarding = 'onboarding';

  static Map<String, WidgetBuilder> routes = {
    AppRoutes.splash: (context) => const SplashScreen(),
    AppRoutes.onboarding: (context) => const OnboardingScreen(),
    AppRoutes.login: (context) => const Login(),
    AppRoutes.register: (context) => const Register(),
    AppRoutes.chooseRole: (context) => const HomeScreen(),
    AppRoutes.editProfileClient: (context) => const EditProfileClientScreen(),
    AppRoutes.editProfileProfessional: (context) =>
        const EditProfileProfessionalScreen(),
    AppRoutes.clientHome: (context) => const ClientHomeScreen(),
    AppRoutes.orders: (context) => const OrdersScreen(),
  };
}
