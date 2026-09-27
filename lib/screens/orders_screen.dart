import 'package:flutter/material.dart';
import 'package:oficios/data/mock_orders.dart';
import 'package:oficios/routes/app_routes.dart';
import 'package:oficios/widgets/app_bottom_nav.dart';
import 'package:oficios/widgets/contact_info_sheet.dart';
import 'package:oficios/widgets/order_card.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int _navIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.help_outline), onPressed: () {}),
        ],
      ),
      body: SafeArea(
        child: mockOrders.isEmpty
            ? Center(
                child: Text('Todavía no tenés pedidos', style: TextStyle(color: Colors.grey.shade600)),
              )
            : ListView(
                padding: const EdgeInsets.all(20),
                children: mockOrders
                    .map((order) => OrderCard(
                          order: order,
                          onViewContact: () => showContactInfoSheet(context, order),
                        ))
                    .toList(),
              ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _navIndex,
        onTap: (index) {
          if (index == _navIndex) return;
          if (index == 0) {
            Navigator.pushReplacementNamed(context, AppRoutes.clientHome);
          } else if (index == 3) {
            Navigator.pushNamed(context, AppRoutes.editProfileClient);
          } else {
            setState(() => _navIndex = index);
          }
        },
      ),
    );
  }
}