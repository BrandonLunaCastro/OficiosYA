import 'package:oficios/data/repositories/order_repository.dart';
import 'package:oficios/models/order_request.dart';

class InMemoryOrderRepository implements OrderRepository {
  InMemoryOrderRepository();

  static final instance = InMemoryOrderRepository();

  final List<OrderRequest> _orders = [];

  @override
  Future<void> createOrder(OrderRequest order) async {
    _orders.add(order);
  }

  @override
  Future<List<OrderRequest>> getOrders() async =>
      List.unmodifiable(_orders.reversed);
}
