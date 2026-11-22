import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oficios/routes/app_routes.dart';
import 'package:oficios/ui/widgets/logout_button.dart';

void main() {
  testWidgets('returns to login when the user closes the session', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        initialRoute: '/client',
        routes: {
          '/client': (_) => Scaffold(
            appBar: AppBar(actions: const [LogoutButton()]),
            body: const Text('Inicio del cliente'),
          ),
          AppRoutes.login: (_) => const Scaffold(body: Text('Iniciar sesión')),
        },
      ),
    );

    await tester.tap(find.byTooltip('Cerrar sesión'));
    await tester.pumpAndSettle();

    expect(find.text('Iniciar sesión'), findsOneWidget);
    expect(find.text('Inicio del cliente'), findsNothing);
  });
}
