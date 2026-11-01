import 'package:flutter_test/flutter_test.dart';
import 'package:oficios/data/repositories/in_memory_order_repository.dart';
import 'package:oficios/models/order_request.dart';

void main() {
  test('InMemoryOrderRepository stores and returns created orders', () async {
    final repository = InMemoryOrderRepository();
    const order = OrderRequest(
      service: 'Plomería',
      providerInitials: 'CR',
      providerName: 'Carlos Rodríguez',
      date: '1 nov',
      time: '12:00',
      phone: '+54 261 555-0129',
      email: 'carlos@example.com',
    );

    expect(await repository.getOrders(), isEmpty);

    await repository.createOrder(order);

    expect(await repository.getOrders(), [order]);
  });
}
