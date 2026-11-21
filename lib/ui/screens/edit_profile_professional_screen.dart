import 'package:flutter/material.dart';
import 'package:oficios/data/repositories/professional_profile_repository.dart';
import 'package:oficios/data/repositories/provider_contact_repository.dart';
import 'package:oficios/routes/app_routes.dart';

class EditProfileProfessionalScreen extends StatefulWidget {
  const EditProfileProfessionalScreen({
    super.key,
    required this.profileRepository,
    required this.contactRepository,
    this.isInitialSetup = false,
  });

  final ProfessionalProfileRepository profileRepository;
  final ProviderContactRepository contactRepository;
  final bool isInitialSetup;

  @override
  State<EditProfileProfessionalScreen> createState() =>
      _EditProfileProfessionalScreenState();
}

class _EditProfileProfessionalScreenState
    extends State<EditProfileProfessionalScreen> {
  static const _backgroundColor = Color(0xFFF4F6FA);
  static const _primaryColor = Color(0xFF2B66DF);

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _specialtyController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _locationController;
  late final TextEditingController _coverageController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final Future<void> _initialization;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _specialtyController = TextEditingController();
    _descriptionController = TextEditingController();
    _locationController = TextEditingController();
    _coverageController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _initialization = widget.isInitialSetup
        ? Future<void>.value()
        : _loadExistingProfile();
  }

  Future<void> _loadExistingProfile() async {
    final profile = await widget.profileRepository.getProfile();
    final contactInfo = await widget.contactRepository.getContactInfo();
    _nameController.text = profile.name;
    _specialtyController.text = profile.specialty;
    _descriptionController.text = profile.about;
    _locationController.text = '${contactInfo.city}, ${contactInfo.province}';
    _coverageController.text = contactInfo.coverageZone;
    _phoneController.text = contactInfo.phone;
    _emailController.text = contactInfo.email;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _specialtyController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _coverageController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
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
              child: Text(
                widget.isInitialSetup
                    ? 'Crear perfil profesional'
                    : 'Editar perfil profesional',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<void>(
                future: _initialization,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('No se pudo cargar el perfil profesional.'),
                    );
                  }
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return _buildForm();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Presentá tus servicios y conectá con clientes de tu zona.',
              style: TextStyle(color: Colors.blueGrey.shade500, fontSize: 12),
            ),
            const SizedBox(height: 12),
            const _FormSectionTitle('Información del perfil'),
            const SizedBox(height: 12),
            _labeledField(
              label: 'Nombre completo',
              hint: 'Ej. Carlos Rodriguez',
              controller: _nameController,
              key: const ValueKey('professional-name'),
            ),
            const SizedBox(height: 10),
            _labeledField(
              label: 'Oficio / especialidad',
              hint: 'Ej. Plomería y Gasista',
              controller: _specialtyController,
              key: const ValueKey('professional-specialty'),
            ),
            const SizedBox(height: 10),
            _labeledField(
              label: 'Descripción de tus servicios',
              hint: 'Contá qué servicios ofrecés y cuál es tu experiencia.',
              controller: _descriptionController,
              key: const ValueKey('professional-description'),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            const _FormSectionTitle('Ubicación'),
            const SizedBox(height: 12),
            _labeledField(
              label: 'Ciudad y provincia',
              hint: 'Ej. Mendoza Capital, Mendoza',
              controller: _locationController,
              key: const ValueKey('professional-location'),
              validator: _validateLocation,
            ),
            const SizedBox(height: 10),
            _labeledField(
              label: 'Zona de cobertura',
              hint: 'Ej. Capital y alrededores',
              controller: _coverageController,
              key: const ValueKey('professional-coverage'),
            ),
            const SizedBox(height: 16),
            const _FormSectionTitle('Medios de contacto'),
            const SizedBox(height: 12),
            _labeledField(
              label: 'Teléfono',
              hint: 'Ej. +54 9 261 444-5678',
              controller: _phoneController,
              key: const ValueKey('professional-phone'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 10),
            _labeledField(
              label: 'Correo electrónico',
              hint: 'Ej. carlos.rod@outlook.com',
              controller: _emailController,
              key: const ValueKey('professional-email'),
              keyboardType: TextInputType.emailAddress,
              textCapitalization: TextCapitalization.none,
              validator: _validateEmail,
            ),
            const SizedBox(height: 10),
            Text(
              'Tu teléfono, correo y zona serán visibles para los clientes en tu perfil.',
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
                  backgroundColor: _primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _isSaving ? null : _saveProfile,
                child: _isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        widget.isInitialSetup
                            ? 'Crear perfil profesional'
                            : 'Guardar perfil profesional',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Podrás editar tu información cuando quieras.',
              style: TextStyle(color: Colors.blueGrey.shade400, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _labeledField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required Key key,
    int maxLines = 1,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.sentences,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        TextFormField(
          key: key,
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          validator: validator ?? _requiredValidator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.blueGrey.shade300, fontSize: 11),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE7EAF0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE7EAF0)),
            ),
          ),
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

  String? _validateLocation(String? value) {
    final locationParts = value?.split(',') ?? [];
    if (locationParts.length < 2 ||
        locationParts.any((part) => part.trim().isEmpty)) {
      return 'Ingresá ciudad y provincia separadas por coma.';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Este campo es obligatorio.';
    }
    final emailParts = value.trim().split('@');
    if (emailParts.length != 2 || !emailParts.last.contains('.')) {
      return 'Ingresá un correo válido.';
    }
    return null;
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      final currentProfile = await widget.profileRepository.getProfile();
      final currentContact = await widget.contactRepository.getContactInfo();
      final locationParts = _locationController.text
          .split(',')
          .map((part) => part.trim())
          .toList();
      final name = _nameController.text.trim();
      final initials = _initialsFor(name);
      final contactInfo = currentContact.copyWith(
        city: locationParts.first,
        province: locationParts.skip(1).join(', '),
        coverageZone: _coverageController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
      );
      final profile = currentProfile.copyWith(
        initials: initials,
        name: name,
        specialty: _specialtyController.text.trim(),
        location: locationParts.first,
        about: _descriptionController.text.trim(),
      );

      await widget.profileRepository.updateProfile(profile);
      await widget.contactRepository.updateContactInfo(contactInfo);
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.professionalProfile);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo guardar el perfil: $error')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  String _initialsFor(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    return parts
        .take(2)
        .map((part) => part.substring(0, 1))
        .join()
        .toUpperCase();
  }
}

class _FormSectionTitle extends StatelessWidget {
  const _FormSectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    );
  }
}
