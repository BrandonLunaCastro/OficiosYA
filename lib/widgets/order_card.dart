import 'package:flutter/material.dart';
import 'package:oficios/models/order_request.dart';

class OrderCard extends StatelessWidget {
  final OrderRequest order;
  final VoidCallback onViewContact;

  const OrderCard({super.key, required this.order, required this.onViewContact});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF2B66DF);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(order.service, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(
                '${order.date} • ${order.time}',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(order.providerName, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: onViewContact,
            child: Row(
              children: [
                const Icon(Icons.phone_outlined, color: primaryColor, size: 16),
                const SizedBox(width: 6),
                const Text(
                  'Ver datos de contacto',
                  style: TextStyle(color: primaryColor, fontWeight: FontWeight.w500, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}