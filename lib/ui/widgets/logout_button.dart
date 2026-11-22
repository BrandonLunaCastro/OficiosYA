import 'package:flutter/material.dart';
import 'package:oficios/routes/app_routes.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Cerrar sesión',
      onPressed: () {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
      },
      icon: const Icon(Icons.logout),
    );
  }
}
