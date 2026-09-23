import 'package:flutter/material.dart';
import 'package:oficios/screens/login_screen.dart';
import 'package:oficios/screens/register_screen.dart';
import 'package:oficios/screens/home_screen.dart';

import 'app_routes.dart';

class AppRouter {
  static final Map<String, WidgetBuilder> routes = {
    AppRoutes.login: (context) => const Login(),
    AppRoutes.register: (context) => const Register(),
    AppRoutes.home: (context) => const HomeScreen(),
  };
}
