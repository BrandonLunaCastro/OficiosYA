import 'package:flutter/material.dart';
import 'package:oficios/models/order_request.dart';
import 'package:oficios/widgets/contact_option_title.dart';

void showContactInfoSheet(BuildContext context, OrderRequest order) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(order.providerName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(order.service, style: TextStyle(color: Colors.grey.shade600)),
            const Divider(height: 24),
            ContactOptionTile(
              icon: Icons.phone_outlined,
              label: 'Teléfono móvil',
              value: order.phone,
              buttonText: 'Llamar',
              onPressed: () {},
            ),
            ContactOptionTile(
              icon: Icons.email_outlined,
              label: 'Correo electrónico',
              value: order.email,
              buttonText: 'Enviar',
              onPressed: () {},
            ),
            const SizedBox(height: 10),
          ],
        ),
      );
    },
  );
}