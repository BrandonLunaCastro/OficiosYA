import 'package:oficios/data/database/app_database.dart';
import 'package:oficios/data/repositories/order_repository.dart';
import 'package:oficios/models/order_request.dart';

class SqliteOrderRepository implements OrderRepository {
  SqliteOrderRepository({AppDatabase? database})
    : _database = database ?? AppDatabase.instance;

  final AppDatabase _database;

  @override
  Future<void> createOrder(OrderRequest order) async {
    final database = await _database.database;
    await database.insert('orders', {
      'service': order.service,
      'provider_initials': order.providerInitials,
      'provider_name': order.providerName,
      'date': order.date,
      'time': order.time,
      'phone': order.phone,
      'email': order.email,
      'client_name': order.clientName,
      'client_phone': order.clientPhone,
      'client_email': order.clientEmail,
      'location': order.location,
      'status': order.status,
    });
  }

  @override
  Future<List<OrderRequest>> getOrders() async {
    final database = await _database.database;
    final rows = await database.query('orders', orderBy: 'id DESC');

    return rows.map(_orderFromRow).toList(growable: false);
  }

  OrderRequest _orderFromRow(Map<String, Object?> row) {
    return OrderRequest(
      service: row['service'] as String,
      providerInitials: row['provider_initials'] as String,
      providerName: row['provider_name'] as String,
      date: row['date'] as String,
      time: row['time'] as String,
      phone: row['phone'] as String,
      email: row['email'] as String,
      clientName: row['client_name'] as String,
      clientPhone: row['client_phone'] as String,
      clientEmail: row['client_email'] as String,
      location: row['location'] as String,
      status: row['status'] as String,
    );
  }
}
