import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oficios/routes/app_routes.dart';
import 'package:oficios/ui/screens/splash_screen.dart';

void main() {
  testWidgets('centers the complete splash content', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        routes: {AppRoutes.onboarding: (_) => const Scaffold()},
        home: const SplashScreen(),
      ),
    );

    final center = tester.getCenter(find.byType(Center));
    final content = tester.getCenter(find.byType(Column).first);

    expect(content.dx, closeTo(center.dx, 0.1));
    expect(content.dy, closeTo(center.dy, 0.1));
    expect(find.text('Encontrá a quien lo resuelve'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
  });
}
