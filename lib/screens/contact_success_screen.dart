import 'package:flutter/material.dart';
import 'package:oficios/models/provider.dart';
import 'package:oficios/routes/app_routes.dart';
import 'package:oficios/widgets/contact_option_title.dart';
import 'package:oficios/widgets/primary_button.dart';

class ContactSuccessScreen extends StatelessWidget {
  final Provider provider;

  const ContactSuccessScreen({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF2B66DF);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check, color: Colors.green.shade600, size: 32),
              ),
              const SizedBox(height: 20),
              const Text(
                '¡Presupuesto Solicitado!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Tu solicitud ha sido enviada con éxito. Ya puedes contactar al prestador para coordinar detalles.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: primaryColor,
                          child: Text(
                            provider.initials,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(provider.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            Row(
                              children: [
                                const Icon(Icons.check_circle, color: Colors.green, size: 12),
                                const SizedBox(width: 4),
                                Text(provider.specialty, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 2),
                        Text('${provider.rating} (${provider.reviews} opiniones)', style: const TextStyle(fontSize: 12)),
                        const SizedBox(width: 12),
                        Icon(Icons.location_on_outlined, size: 14, color: Colors.grey.shade600),
                        Text(' ${provider.distanceKm}km', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                      ],
                    ),
                    const Divider(height: 24),
                    ContactOptionTile(
                      icon: Icons.phone_outlined,
                      label: 'Teléfono móvil',
                      value: provider.phone,
                      buttonText: 'Llamar',
                      onPressed: () {
                        // Acá se podría integrar url_launcher para llamar de verdad
                      },
                    ),
                    ContactOptionTile(
                      icon: Icons.email_outlined,
                      label: 'Correo electrónico',
                      value: provider.email,
                      buttonText: 'Enviar',
                      onPressed: () {
                        // Acá se podría integrar url_launcher para abrir el mail
                      },
                    ),
                  ],
                ),
              ),
              const Spacer(),
              PrimaryButton(
                text: 'Volver al inicio',
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.clientHome,
                    (route) => false,
                  );
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}