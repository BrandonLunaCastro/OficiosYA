import 'package:oficios/models/order_request.dart';

abstract interface class OrderRepository {
  Future<List<OrderRequest>> getOrders();

  Future<void> createOrder(OrderRequest order);
}
