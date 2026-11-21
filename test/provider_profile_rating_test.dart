import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oficios/data/mocks/mock_provider.dart';
import 'package:oficios/data/repositories/in_memory_order_repository.dart';
import 'package:oficios/data/repositories/in_memory_user_profile_repository.dart';
import 'package:oficios/data/repositories/mock_provider_review_repository.dart';
import 'package:oficios/ui/screens/provider_profile_screen.dart';

void main() {
  testWidgets('califica al prestador sin reutilizar controladores', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ProviderProfileScreen(
          provider: mockProviders.first,
          orderRepository: InMemoryOrderRepository.instance,
          profileRepository: InMemoryUserProfileRepository.instance,
          reviewRepository: MockProviderReviewRepository.instance,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Calificar prestador'));
    await tester.pumpAndSettle();

    expect(find.text('Calificar prestador'), findsWidgets);
    await tester.tap(find.byTooltip('5 estrellas'));
    await tester.enterText(find.byType(TextField), 'Excelente atención.');
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    expect(find.text('Calificación registrada'), findsOneWidget);
  });
}
