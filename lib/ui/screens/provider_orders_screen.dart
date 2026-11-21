import 'package:flutter/material.dart';
import 'package:oficios/data/repositories/order_repository.dart';
import 'package:oficios/data/repositories/professional_profile_repository.dart';
import 'package:oficios/models/order_request.dart';
import 'package:oficios/routes/app_routes.dart';
import 'package:oficios/ui/widgets/provider_bottom_nav.dart';
import 'package:url_launcher/url_launcher.dart';

class ProviderOrdersScreen extends StatefulWidget {
  const ProviderOrdersScreen({
    super.key,
    required this.orderRepository,
    required this.profileRepository,
  });

  final OrderRepository orderRepository;
  final ProfessionalProfileRepository profileRepository;

  @override
  State<ProviderOrdersScreen> createState() => _ProviderOrdersScreenState();
}

class _ProviderOrdersScreenState extends State<ProviderOrdersScreen> {
  static const _backgroundColor = Color(0xFFF4F6FA);

  late Future<_ProviderOrdersData> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = _loadOrders();
  }

  Future<_ProviderOrdersData> _loadOrders() async {
    final profile = await widget.profileRepository.getProfile();
    final orders = await widget.orderRepository.getOrders();
    final providerName = _normalizeName(profile.name);
    return _ProviderOrdersData(
      orders: orders
          .where((order) => _normalizeName(order.providerName) == providerName)
          .toList(),
    );
  }

  String _normalizeName(String value) {
    const replacements = {
      'á': 'a',
      'é': 'e',
      'í': 'i',
      'ó': 'o',
      'ú': 'u',
      'ü': 'u',
      'ñ': 'n',
    };
    return value.trim().toLowerCase().replaceAllMapped(
      RegExp('[áéíóúüñ]'),
      (match) => replacements[match[0]!]!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text(
          'Solicitudes de contacto',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<_ProviderOrdersData>(
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

            final orders = snapshot.data!.orders;
            if (orders.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.assignment_outlined,
                        color: Colors.blueGrey.shade300,
                        size: 44,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Todavía no tenés pedidos',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Cuando un cliente solicite tus servicios, sus datos aparecerán acá.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.blueGrey.shade500,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              children: [
                Text(
                  'Clientes que solicitaron tus datos de contacto.',
                  style: TextStyle(
                    color: Colors.blueGrey.shade600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  '${orders.length} ${orders.length == 1 ? 'solicitud recibida' : 'solicitudes recibidas'}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                for (final order in orders)
                  _ClientOrderCard(
                    order: order,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            ProviderOrderDetailsScreen(order: order),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: ProviderBottomNav(
        currentIndex: 2,
        onTap: _handleNavigation,
      ),
    );
  }

  void _handleNavigation(int index) {
    final route = switch (index) {
      0 => AppRoutes.professionalProfile,
      1 => AppRoutes.providerServices,
      2 => null,
      3 => AppRoutes.providerContact,
      4 => AppRoutes.providerReviews,
      _ => null,
    };
    if (route != null) {
      Navigator.pushNamed(context, route);
    }
  }
}

class _ProviderOrdersData {
  const _ProviderOrdersData({required this.orders});

  final List<OrderRequest> orders;
}

class _ClientOrderCard extends StatelessWidget {
  const _ClientOrderCard({required this.order, required this.onTap});

  static const _primaryColor = Color(0xFF2B66DF);

  final OrderRequest order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final clientName = order.clientName.trim().isEmpty
        ? 'Cliente'
        : order.clientName.trim();

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE7EAF0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    order.service,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '${order.date} • ${order.time}',
                  style: TextStyle(
                    color: Colors.blueGrey.shade500,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              clientName,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            InkWell(
              onTap: onTap,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.phone_outlined, color: _primaryColor, size: 15),
                  SizedBox(width: 5),
                  Text(
                    'Ver datos del cliente',
                    style: TextStyle(
                      color: _primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProviderOrderDetailsScreen extends StatelessWidget {
  const ProviderOrderDetailsScreen({super.key, required this.order});

  final OrderRequest order;

  @override
  Widget build(BuildContext context) {
    final clientName = order.clientName.trim().isEmpty
        ? 'Cliente'
        : order.clientName.trim();
    final initials = _clientInitials(clientName);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Datos del cliente',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            Text(
              'Este cliente solicitó tus datos de contacto.',
              style: TextStyle(color: Colors.blueGrey.shade600, fontSize: 13),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE7EAF0)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 23,
                    backgroundColor: const Color(0xFFEAF0FF),
                    child: Text(
                      initials,
                      style: const TextStyle(
                        color: Color(0xFF2B66DF),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          clientName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          order.service,
                          style: const TextStyle(
                            color: Color(0xFF2B66DF),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${order.date} • ${order.time}',
                          style: TextStyle(
                            color: Colors.blueGrey.shade500,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Datos de contacto',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _ContactMethod(
              icon: Icons.phone_outlined,
              label: 'Teléfono móvil',
              value: order.clientPhone,
              buttonLabel: 'Llamar al cliente',
              onPressed: () => _launchContact(
                context,
                Uri(scheme: 'tel', path: order.clientPhone.trim()),
                'No se pudo iniciar la llamada.',
              ),
              enabled: order.clientPhone.trim().isNotEmpty,
            ),
            const SizedBox(height: 10),
            _ContactMethod(
              icon: Icons.email_outlined,
              label: 'Correo electrónico',
              value: order.clientEmail,
              buttonLabel: 'Enviar correo',
              onPressed: () => _launchContact(
                context,
                Uri(scheme: 'mailto', path: order.clientEmail.trim()),
                'No se pudo abrir el correo.',
              ),
              outlined: true,
              enabled: order.clientEmail.trim().isNotEmpty,
            ),
            const SizedBox(height: 10),
            Text(
              'Coordiná los detalles directamente con el cliente.',
              style: TextStyle(color: Colors.blueGrey.shade500, fontSize: 11),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ProviderBottomNav(
        currentIndex: 2,
        onTap: (index) {
          final route = switch (index) {
            0 => AppRoutes.professionalProfile,
            1 => AppRoutes.providerServices,
            2 => null,
            3 => AppRoutes.providerContact,
            4 => AppRoutes.providerReviews,
            _ => null,
          };
          if (route != null) {
            Navigator.pushNamed(context, route);
          }
        },
      ),
    );
  }
}

class _ContactMethod extends StatelessWidget {
  const _ContactMethod({
    required this.icon,
    required this.label,
    required this.value,
    required this.buttonLabel,
    required this.onPressed,
    this.outlined = false,
    this.enabled = true,
  });

  final IconData icon;
  final String label;
  final String value;
  final String buttonLabel;
  final VoidCallback onPressed;
  final bool outlined;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final displayedValue = value.trim().isEmpty ? 'No disponible' : value;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE7EAF0)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF2B66DF), size: 16),
              const SizedBox(width: 7),
              Text(
                label,
                style: TextStyle(color: Colors.blueGrey.shade500, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            displayedValue,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 40,
            child: outlined
                ? OutlinedButton(
                    onPressed: enabled ? onPressed : null,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF2B66DF),
                      side: const BorderSide(color: Color(0xFF2B66DF)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(buttonLabel),
                  )
                : FilledButton(
                    onPressed: enabled ? onPressed : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF2B66DF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(buttonLabel),
                  ),
          ),
        ],
      ),
    );
  }
}

String _clientInitials(String name) {
  final words = name
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .take(2);
  final initials = words.map((word) => word[0].toUpperCase()).join();
  return initials.isEmpty ? '?' : initials;
}

Future<void> _launchContact(
  BuildContext context,
  Uri uri,
  String errorMessage,
) async {
  try {
    final launched = await launchUrl(uri);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  } catch (error) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('$errorMessage $error')));
  }
}
