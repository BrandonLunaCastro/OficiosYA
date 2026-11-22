import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:oficios/data/database/app_database.dart';
import 'package:oficios/data/repositories/sqlite_order_repository.dart';
import 'package:oficios/models/order_request.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test('persists orders after closing and reopening the database', () async {
    final directory = await Directory.systemTemp.createTemp('oficios_sqlite_');
    addTearDown(() async {
      if (await directory.exists()) {
        await directory.delete(recursive: true);
      }
    });
    final databasePath = path.join(directory.path, 'orders.db');
    final firstDatabase = AppDatabase(databasePath: databasePath);
    addTearDown(firstDatabase.close);

    const firstOrder = OrderRequest(
      service: 'Plomería',
      providerInitials: 'CR',
      providerName: 'Carlos Rodríguez',
      date: '1 nov',
      time: '12:00',
      phone: '+54 261 555-0129',
      email: 'carlos@example.com',
    );
    const secondOrder = OrderRequest(
      service: 'Electricidad',
      providerInitials: 'MP',
      providerName: 'María Pérez',
      date: '2 nov',
      time: '14:00',
      phone: '+54 261 555-0130',
      email: 'maria@example.com',
      clientName: 'Ana Gómez',
      clientPhone: '+54 261 555-0140',
      clientEmail: 'ana@example.com',
      location: 'Godoy Cruz',
      status: 'Aceptado',
    );

    final firstRepository = SqliteOrderRepository(database: firstDatabase);
    await firstRepository.createOrder(firstOrder);
    await firstRepository.createOrder(secondOrder);
    await firstDatabase.close();

    final reopenedDatabase = AppDatabase(databasePath: databasePath);
    addTearDown(reopenedDatabase.close);
    final reopenedRepository = SqliteOrderRepository(
      database: reopenedDatabase,
    );
    final orders = await reopenedRepository.getOrders();

    expect(orders.map((order) => order.service), ['Electricidad', 'Plomería']);
    expect(orders.first.clientName, 'Ana Gómez');
    expect(orders.first.location, 'Godoy Cruz');
    expect(orders.first.status, 'Aceptado');
  });
}
