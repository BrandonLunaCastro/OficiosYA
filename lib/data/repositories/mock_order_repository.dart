import 'package:oficios/data/mocks/mock_orders.dart';
import 'package:oficios/data/repositories/order_repository.dart';
import 'package:oficios/models/order_request.dart';

class MockOrderRepository implements OrderRepository {
  const MockOrderRepository();

  @override
  Future<List<OrderRequest>> getOrders() async => List.unmodifiable(mockOrders);
}
