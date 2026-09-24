import 'package:flutter/material.dart';
import 'package:oficios/screens/client_home_screen.dart';
import 'package:oficios/screens/login_screen.dart';
import 'package:oficios/screens/register_screen.dart';
import 'package:oficios/screens/home_screen.dart';
import 'package:oficios/screens/edit_profile_client_screen.dart';
import 'package:oficios/screens/edit_profile_professional_screen.dart';

import 'app_routes.dart';

class AppRouter {
  static Map<String, WidgetBuilder> routes = {
    AppRoutes.login: (context) => const Login(),
    AppRoutes.register: (context) => const Register(),
    AppRoutes.chooseRole: (context) => const HomeScreen(),
    AppRoutes.editProfileClient: (context) => const EditProfileClientScreen(),
    AppRoutes.editProfileProfessional: (context) => const EditProfileProfessionalScreen(),
    AppRoutes.clientHome: (context) => const ClientHomeScreen(),
  };
}