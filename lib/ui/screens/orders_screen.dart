import 'package:flutter/material.dart';
import 'package:oficios/data/repositories/order_repository.dart';
import 'package:oficios/models/order_request.dart';
import 'package:oficios/routes/app_routes.dart';
import 'package:oficios/ui/widgets/app_bottom_nav.dart';
import 'package:oficios/ui/widgets/contact_info_sheet.dart';
import 'package:oficios/ui/widgets/order_card.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key, required this.orderRepository});

  final OrderRepository orderRepository;

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int _navIndex = 2;
  late final Future<List<OrderRequest>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = widget.orderRepository.getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pedidos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.help_outline), onPressed: () {}),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<List<OrderRequest>>(
          future: _ordersFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('No se pudieron cargar los pedidos.'),
              );
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final orders = snapshot.data!;
            if (orders.isEmpty) {
              return Center(
                child: Text(
                  'Todavía no tenés pedidos',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              );
            }
            return ListView(
              padding: const EdgeInsets.all(20),
              children: orders
                  .map(
                    (order) => OrderCard(
                      order: order,
                      onViewContact: () => showContactInfoSheet(context, order),
                    ),
                  )
                  .toList(),
            );
          },
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
