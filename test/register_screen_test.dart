import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oficios/data/repositories/auth_repository.dart';
import 'package:oficios/models/auth_account.dart';
import 'package:oficios/ui/screens/register_screen.dart';

void main() {
  testWidgets('registers a professional account with the selected role', (
    tester,
  ) async {
    final registrationRepository = _RecordingRegistrationRepository();
    await tester.pumpWidget(
      MaterialApp(
        initialRoute: '/login',
        routes: {
          '/login': (_) => Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () => Navigator.pushNamed(context, '/register'),
                child: const Text('Abrir registro'),
              ),
            ),
          ),
          '/register': (_) =>
              Register(registrationRepository: registrationRepository),
        },
      ),
    );

    await tester.tap(find.text('Abrir registro'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), 'Ana Gómez');
    await tester.enterText(find.byType(TextField).at(1), 'ana@example.com');
    await tester.enterText(find.byType(TextField).at(2), '2615550001');
    await tester.tap(find.byType(DropdownButtonFormField<AccountRole>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Prestador de servicios').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(3), 'Plomería');
    await tester.enterText(
      find.byType(TextField).at(4),
      'Reparaciones domiciliarias.',
    );
    await tester.enterText(find.byType(TextField).at(5), 'Password123');
    await tester.ensureVisible(find.byType(Checkbox));
    await tester.tap(find.byType(Checkbox));
    await tester.ensureVisible(find.text('Registrarse'));
    await tester.tap(find.text('Registrarse'));
    await tester.pumpAndSettle();

    expect(registrationRepository.role, AccountRole.professional);
    expect(registrationRepository.specialty, 'Plomería');
    expect(find.text('Abrir registro'), findsOneWidget);
  });
}

class _RecordingRegistrationRepository
    implements AccountRegistrationRepository {
  AccountRole? role;
  String? specialty;

  @override
  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required AccountRole role,
    String specialty = '',
    String about = '',
  }) async {
    this.role = role;
    this.specialty = specialty;
  }
}
