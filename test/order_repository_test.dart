import 'package:flutter_test/flutter_test.dart';
import 'package:oficios/data/repositories/mock_order_repository.dart';

void main() {
  test('MockOrderRepository loads mock orders asynchronously', () async {
    const repository = MockOrderRepository();

    final orders = await repository.getOrders();

    expect(orders, isNotEmpty);
    expect(orders.first.providerName, 'Carlos Rodríguez');
  });
}
