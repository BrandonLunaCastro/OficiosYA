import 'package:flutter/material.dart';
import 'package:oficios/data/repositories/provider_contact_repository.dart';
import 'package:oficios/models/provider_contact_info.dart';
import 'package:oficios/routes/app_routes.dart';
import 'package:oficios/ui/widgets/provider_bottom_nav.dart';

class ProviderContactScreen extends StatefulWidget {
  const ProviderContactScreen({super.key, required this.contactRepository});

  final ProviderContactRepository contactRepository;

  @override
  State<ProviderContactScreen> createState() => _ProviderContactScreenState();
}

class _ProviderContactScreenState extends State<ProviderContactScreen> {
  static const _backgroundColor = Color(0xFFF4F6FA);
  static const _primaryColor = Color(0xFF2B66DF);

  late Future<ProviderContactInfo> _contactFuture;

  @override
  void initState() {
    super.initState();
    _contactFuture = widget.contactRepository.getContactInfo();
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
                'Ubicación y contacto',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: FutureBuilder<ProviderContactInfo>(
                future: _contactFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        'No se pudo cargar tu información de contacto.',
                      ),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return _ContactContent(
                    contactInfo: snapshot.data!,
                    onEditLocation: () => _editContactInfo(
                      snapshot.data!,
                      _ContactEditSection.location,
                    ),
                    onEditContact: () => _editContactInfo(
                      snapshot.data!,
                      _ContactEditSection.contact,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ProviderBottomNav(
        currentIndex: 3,
        onTap: _handleNavigation,
      ),
    );
  }

  void _handleNavigation(int index) {
    final route = switch (index) {
      0 => AppRoutes.professionalProfile,
      1 => AppRoutes.providerServices,
      2 => AppRoutes.providerOrders,
      3 => null,
      4 => AppRoutes.providerReviews,
      _ => null,
    };
    if (route != null) {
      Navigator.pushNamed(context, route);
    }
  }

  Future<void> _editContactInfo(
    ProviderContactInfo contactInfo,
    _ContactEditSection section,
  ) async {
    final updatedContact = await showDialog<ProviderContactInfo>(
      context: context,
      builder: (context) =>
          _ContactEditorDialog(contactInfo: contactInfo, section: section),
    );
    if (updatedContact == null) return;

    try {
      await widget.contactRepository.updateContactInfo(updatedContact);
      if (!mounted) return;
      setState(() {
        _contactFuture = widget.contactRepository.getContactInfo();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Información actualizada correctamente.')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo guardar la información: $error')),
      );
    }
  }
}

class _ContactContent extends StatelessWidget {
  const _ContactContent({
    required this.contactInfo,
    required this.onEditLocation,
    required this.onEditContact,
  });

  final ProviderContactInfo contactInfo;
  final VoidCallback onEditLocation;
  final VoidCallback onEditContact;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Definí dónde trabajás y cómo contactarte.',
            style: TextStyle(color: Colors.blueGrey.shade500, fontSize: 12),
          ),
          const SizedBox(height: 12),
          _ContactCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ubicación',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  '${contactInfo.city}, ${contactInfo.province}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Zona de cobertura: ${contactInfo.coverageZone}.',
                  style: TextStyle(
                    color: Colors.blueGrey.shade500,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 4),
                _EditLink(
                  label: 'Editar ubicación y cobertura',
                  onPressed: onEditLocation,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          _ContactCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tus medios de contacto',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                _ContactValue(label: 'Teléfono', value: contactInfo.phone),
                const SizedBox(height: 8),
                _ContactValue(
                  label: 'Correo electrónico',
                  value: contactInfo.email,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Estos datos se mostrarán en tu perfil para que los clientes puedan contactarte directamente.',
            style: TextStyle(
              color: Colors.blueGrey.shade400,
              fontSize: 10,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 42,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: _ProviderContactScreenState._primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: onEditContact,
              child: const Text(
                'Editar medios de contacto',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactValue extends StatelessWidget {
  const _ContactValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.blueGrey.shade500, fontSize: 10),
        ),
        const SizedBox(height: 3),
        Text(value, style: const TextStyle(fontSize: 11)),
      ],
    );
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE7EAF0)),
      ),
      child: child,
    );
  }
}

class _EditLink extends StatelessWidget {
  const _EditLink({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        minimumSize: Size.zero,
        padding: const EdgeInsets.only(top: 6),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        foregroundColor: _ProviderContactScreenState._primaryColor,
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
      ),
    );
  }
}

enum _ContactEditSection { location, contact }

class _ContactEditorDialog extends StatefulWidget {
  const _ContactEditorDialog({
    required this.contactInfo,
    required this.section,
  });

  final ProviderContactInfo contactInfo;
  final _ContactEditSection section;

  @override
  State<_ContactEditorDialog> createState() => _ContactEditorDialogState();
}

class _ContactEditorDialogState extends State<_ContactEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _cityController;
  late final TextEditingController _provinceController;
  late final TextEditingController _coverageController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _cityController = TextEditingController(text: widget.contactInfo.city);
    _provinceController = TextEditingController(
      text: widget.contactInfo.province,
    );
    _coverageController = TextEditingController(
      text: widget.contactInfo.coverageZone,
    );
    _phoneController = TextEditingController(text: widget.contactInfo.phone);
    _emailController = TextEditingController(text: widget.contactInfo.email);
  }

  @override
  void dispose() {
    _cityController.dispose();
    _provinceController.dispose();
    _coverageController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLocation = widget.section == _ContactEditSection.location;
    final title = isLocation
        ? 'Editar ubicación y cobertura'
        : 'Editar medios de contacto';
    final icon = isLocation
        ? Icons.location_on_outlined
        : Icons.contact_phone_outlined;

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
            child: Icon(icon, color: const Color(0xFF2B66DF)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: isLocation
                  ? [
                      _field(_cityController, 'Ciudad', hint: 'Ej. Mendoza'),
                      _field(
                        _provinceController,
                        'Provincia',
                        hint: 'Ej. Mendoza',
                      ),
                      _field(
                        _coverageController,
                        'Zona de cobertura',
                        hint: 'Ej. Capital y alrededores',
                      ),
                    ]
                  : [
                      _field(
                        _phoneController,
                        'Teléfono',
                        hint: '+54 9 261 123-4567',
                        keyboardType: TextInputType.phone,
                        validatePhone: true,
                      ),
                      _field(
                        _emailController,
                        'Correo electrónico',
                        hint: 'nombre@correo.com',
                        keyboardType: TextInputType.emailAddress,
                        validateEmail: true,
                      ),
                    ],
            ),
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
          child: const Text('Guardar cambios'),
        ),
      ],
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    TextInputType? keyboardType,
    bool validateEmail = false,
    bool validatePhone = false,
    String? hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          filled: true,
          fillColor: const Color(0xFFF8F9FC),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE3E7EF)),
          ),
        ),
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Este campo es obligatorio.';
          }
          final text = value.trim();
          if (validateEmail &&
              (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(text))) {
            return 'Ingresá un correo válido.';
          }
          if (validatePhone) {
            final digits = text.replaceAll(RegExp(r'[^0-9]'), '');
            if (digits.length < 8) {
              return 'Ingresá un teléfono válido.';
            }
          }
          return null;
        },
      ),
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final updatedInfo = widget.section == _ContactEditSection.location
        ? widget.contactInfo.copyWith(
            city: _cityController.text,
            province: _provinceController.text,
            coverageZone: _coverageController.text,
          )
        : widget.contactInfo.copyWith(
            phone: _phoneController.text,
            email: _emailController.text,
          );
    Navigator.pop(context, updatedInfo);
  }
}
