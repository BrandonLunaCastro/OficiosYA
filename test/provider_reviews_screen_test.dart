import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oficios/data/repositories/mock_provider_review_repository.dart';
import 'package:oficios/ui/screens/provider_reviews_screen.dart';

void main() {
  testWidgets('shows provider rating breakdown and lets sort reviews', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ProviderReviewsScreen(
          reviewRepository: MockProviderReviewRepository(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Valoraciones'), findsOneWidget);
    expect(find.text('4.8'), findsOneWidget);
    expect(find.text('45 opiniones de clientes'), findsOneWidget);
    expect(find.text('36'), findsOneWidget);
    expect(find.text('9'), findsOneWidget);
    expect(find.text('Lucía Martínez'), findsOneWidget);
    expect(find.text('Diego Fernández'), findsOneWidget);

    await tester.tap(find.text('Más recientes'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mejor valoradas').last);
    await tester.pumpAndSettle();

    expect(find.text('Mejor valoradas'), findsOneWidget);
    expect(
      find.text(
        'Muy puntual y prolijo. Solucionó la pérdida de agua y dejó todo funcionando. ¡Lo recomiendo!',
      ),
      findsOneWidget,
    );
  });
}
