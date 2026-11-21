import 'package:flutter/material.dart';
import 'package:oficios/data/repositories/provider_service_repository.dart';
import 'package:oficios/models/provider_service.dart';
import 'package:oficios/routes/app_routes.dart';
import 'package:oficios/ui/widgets/provider_bottom_nav.dart';

class ProviderServicesScreen extends StatefulWidget {
  const ProviderServicesScreen({super.key, required this.serviceRepository});

  final ProviderServiceRepository serviceRepository;

  @override
  State<ProviderServicesScreen> createState() => _ProviderServicesScreenState();
}

class _ProviderServicesScreenState extends State<ProviderServicesScreen> {
  static const _primaryColor = Color(0xFF2B66DF);
  static const _backgroundColor = Color(0xFFF4F6FA);

  late Future<List<ProviderService>> _servicesFuture;

  @override
  void initState() {
    super.initState();
    _servicesFuture = widget.serviceRepository.getServices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 64,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: Colors.white,
              child: const Text(
                'Mis servicios',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<ProviderService>>(
                future: _servicesFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('No se pudieron cargar tus servicios.'),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return _ServicesContent(
                    services: snapshot.data!,
                    onAddService: () => _openServiceEditor(),
                    onEditService: _openServiceEditor,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ProviderBottomNav(
        currentIndex: 1,
        onTap: _handleNavigation,
      ),
    );
  }

  void _handleNavigation(int index) {
    if (index == 0) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      } else {
        Navigator.pushNamed(context, AppRoutes.professionalProfile);
      }
    } else if (index == 2) {
      Navigator.pushNamed(context, AppRoutes.providerOrders);
    } else if (index == 3) {
      Navigator.pushNamed(context, AppRoutes.providerContact);
    } else if (index == 4) {
      Navigator.pushNamed(context, AppRoutes.providerReviews);
    } else if (index != 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Esta sección estará disponible próximamente.'),
        ),
      );
    }
  }

  Future<void> _openServiceEditor([ProviderService? service]) async {
    final result = await showDialog<_ServiceFormResult>(
      context: context,
      builder: (context) => _ServiceEditorDialog(service: service),
    );
    if (result == null) return;

    try {
      if (service == null) {
        await widget.serviceRepository.addService(
          title: result.title,
          description: result.description,
        );
      } else {
        await widget.serviceRepository.updateService(
          service.copyWith(
            title: result.title,
            description: result.description,
          ),
        );
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            service == null
                ? 'Servicio agregado correctamente.'
                : 'Servicio actualizado correctamente.',
          ),
        ),
      );
      setState(() {
        _servicesFuture = widget.serviceRepository.getServices();
      });
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo guardar el servicio: $error')),
      );
    }
  }
}

class _ServicesContent extends StatelessWidget {
  const _ServicesContent({
    required this.services,
    required this.onAddService,
    required this.onEditService,
  });

  final List<ProviderService> services;
  final VoidCallback onAddService;
  final ValueChanged<ProviderService> onEditService;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Mostrá a los clientes qué podés hacer.',
            style: TextStyle(color: Colors.blueGrey.shade500, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Text(
            'Servicios publicados · ${services.length}',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          for (final service in services) ...[
            _ServiceCard(
              service: service,
              onEdit: () => onEditService(service),
            ),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 1),
          SizedBox(
            height: 42,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: _ProviderServicesScreenState._primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: onAddService,
              child: const Text(
                'Agregar servicio',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Los cambios se muestran en tu perfil público.',
            style: TextStyle(color: Colors.blueGrey.shade400, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.service, required this.onEdit});

  final ProviderService service;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE7EAF0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            service.title,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            service.description,
            style: TextStyle(
              color: Colors.blueGrey.shade500,
              fontSize: 11,
              height: 1.3,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: onEdit,
              style: TextButton.styleFrom(
                minimumSize: Size.zero,
                padding: const EdgeInsets.only(top: 6),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                foregroundColor: _ProviderServicesScreenState._primaryColor,
              ),
              child: const Text(
                'Editar servicio',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceFormResult {
  const _ServiceFormResult({required this.title, required this.description});

  final String title;
  final String description;
}

class _ServiceEditorDialog extends StatefulWidget {
  const _ServiceEditorDialog({this.service});

  final ProviderService? service;

  @override
  State<_ServiceEditorDialog> createState() => _ServiceEditorDialogState();
}

class _ServiceEditorDialogState extends State<_ServiceEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.service?.title);
    _descriptionController = TextEditingController(
      text: widget.service?.description,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.service != null;

    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      titlePadding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
      contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
      actionsPadding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF0FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.handyman_outlined,
              color: Color(0xFF2B66DF),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isEditing ? 'Editar servicio' : 'Agregar servicio',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Completá la información que verán tus clientes.',
                  style: TextStyle(color: Colors.blueGrey, fontSize: 12),
                ),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _titleController,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.sentences,
                decoration: _dialogInputDecoration(
                  label: 'Nombre del servicio',
                  hint: 'Ej. Reparación de cañerías',
                ),
                validator: _requiredValidator,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: _dialogInputDecoration(
                  label: 'Descripción',
                  hint: 'Indicá qué incluye el servicio',
                ),
                textCapitalization: TextCapitalization.sentences,
                maxLines: 4,
                validator: _requiredValidator,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _save,
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(isEditing ? 'Guardar cambios' : 'Agregar'),
        ),
      ],
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Este campo es obligatorio.';
    }
    return null;
  }

  InputDecoration _dialogInputDecoration({
    required String label,
    required String hint,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF8F9FC),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE3E7EF)),
      ),
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      _ServiceFormResult(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
      ),
    );
  }
}
