import 'package:flutter/material.dart';
import 'package:oficios/routes/app_routes.dart';
import 'package:oficios/ui/widgets/logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _goToOnboarding();
  }

  Future<void> _goToOnboarding() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Logo(label: 'OficiosYA'),
              SizedBox(height: 12),
              Text('Encontrá a quien lo resuelve'),
            ],
          ),
        ),
      ),
    );
  }
}
