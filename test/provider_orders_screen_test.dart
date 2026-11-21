import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oficios/data/repositories/in_memory_order_repository.dart';
import 'package:oficios/data/repositories/mock_professional_profile_repository.dart';
import 'package:oficios/models/order_request.dart';
import 'package:oficios/ui/screens/provider_orders_screen.dart';

void main() {
  testWidgets('shows only incoming orders for the signed-in provider', (
    tester,
  ) async {
    final orderRepository = InMemoryOrderRepository();
    await orderRepository.createOrder(
      const OrderRequest(
        service: 'Plomería',
        providerInitials: 'CR',
        providerName: 'Carlos Rodríguez',
        date: '24 sep',
        time: '10:30',
        phone: '+54 261 555-0001',
        email: 'prestador@example.com',
        clientName: 'Lucas Gómez',
        clientPhone: '+54 9 261 555-1234',
        clientEmail: 'lucas.gomez@gmail.com',
      ),
    );
    await orderRepository.createOrder(
      const OrderRequest(
        service: 'Electricidad',
        providerInitials: 'VS',
        providerName: 'Valeria Sanchez',
        date: '24 sep',
        time: '11:00',
        phone: '+54 261 555-0002',
        email: 'otra@example.com',
        clientName: 'Otro Cliente',
        clientPhone: '+54 9 261 555-0000',
        clientEmail: 'otro@example.com',
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ProviderOrdersScreen(
          orderRepository: orderRepository,
          profileRepository: MockProfessionalProfileRepository(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Solicitudes de contacto'), findsOneWidget);
    expect(find.text('1 solicitud recibida'), findsOneWidget);
    expect(find.text('Lucas Gómez'), findsOneWidget);
    expect(find.text('Plomería'), findsOneWidget);
    expect(find.text('Ver datos del cliente'), findsOneWidget);
    expect(find.text('+54 9 261 555-1234'), findsNothing);
    expect(find.text('lucas.gomez@gmail.com'), findsNothing);
    expect(find.text('Otro Cliente'), findsNothing);

    await tester.tap(find.text('Ver datos del cliente'));
    await tester.pumpAndSettle();

    expect(find.text('Datos del cliente'), findsOneWidget);
    expect(find.text('+54 9 261 555-1234'), findsOneWidget);
    expect(find.text('lucas.gomez@gmail.com'), findsOneWidget);
    expect(find.text('Llamar al cliente'), findsOneWidget);
    expect(find.text('Enviar correo'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Solicitudes de contacto'), findsOneWidget);
  });
}
