import 'package:flutter/material.dart';
import 'package:oficios/data/repositories/auth_repository.dart';
import 'package:oficios/models/auth_account.dart';
import 'package:oficios/ui/widgets/custom_password_field.dart';
import 'package:oficios/ui/widgets/custom_text_field.dart';
import 'package:oficios/ui/widgets/primary_button.dart';
import 'package:oficios/ui/widgets/terms_checkbox.dart';

class Register extends StatefulWidget {
  const Register({super.key, required this.registrationRepository});

  final AccountRegistrationRepository registrationRepository;

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _specialtyController = TextEditingController();
  final _aboutController = TextEditingController();
  final _passwordController = TextEditingController();

  AccountRole _selectedRole = AccountRole.client;
  bool _acceptedTerms = false;
  bool _isRegistering = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _specialtyController.dispose();
    _aboutController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_isRegistering) return;

    final name = _nameController.text.trim();
    final email = _emailController.text.trim().toLowerCase();
    final phone = _phoneController.text.trim();
    final specialty = _specialtyController.text.trim();
    final about = _aboutController.text.trim();
    final password = _passwordController.text;

    if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty) {
      _showMessage('Completá nombre, correo, teléfono y contraseña.');
      return;
    }
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      _showMessage('Ingresá un correo electrónico válido.');
      return;
    }
    if (password.length < 8) {
      _showMessage('La contraseña debe tener al menos 8 caracteres.');
      return;
    }
    if (_selectedRole == AccountRole.professional &&
        (specialty.isEmpty || about.isEmpty)) {
      _showMessage('Completá tu oficio y una breve descripción.');
      return;
    }
    if (!_acceptedTerms) {
      _showMessage('Debés aceptar los términos y condiciones.');
      return;
    }

    setState(() => _isRegistering = true);
    try {
      await widget.registrationRepository.register(
        name: name,
        email: email,
        phone: phone,
        password: password,
        role: _selectedRole,
        specialty: specialty,
        about: about,
      );
      if (!mounted) return;
      Navigator.pop(context, email);
    } on AccountRegistrationException catch (error) {
      if (!mounted) return;
      _showMessage(error.toString());
    } catch (error) {
      if (!mounted) return;
      _showMessage('No se pudo crear la cuenta: $error');
    } finally {
      if (mounted) setState(() => _isRegistering = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final isProfessional = _selectedRole == AccountRole.professional;

    return Scaffold(
      appBar: AppBar(title: const Text('Crear cuenta')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              CustomTextField(
                label: 'Nombre completo',
                hint: 'Ej. Lucas Gómez',
                controller: _nameController,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: 'Correo electrónico',
                hint: 'Ej. nombre@correo.com',
                controller: _emailController,
                keyBoardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: 'Número de teléfono',
                hint: 'Ej. 261 555-1234',
                controller: _phoneController,
                keyBoardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: DropdownButtonFormField<AccountRole>(
                  initialValue: _selectedRole,
                  decoration: const InputDecoration(
                    labelText: 'Tipo de cuenta',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: AccountRole.client,
                      child: Text('Cliente'),
                    ),
                    DropdownMenuItem(
                      value: AccountRole.professional,
                      child: Text('Prestador de servicios'),
                    ),
                  ],
                  onChanged: (role) {
                    if (role != null) {
                      setState(() => _selectedRole = role);
                    }
                  },
                ),
              ),
              if (isProfessional) ...[
                const SizedBox(height: 20),
                CustomTextField(
                  label: 'Oficio o servicio',
                  hint: 'Ej. Plomería',
                  controller: _specialtyController,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: 'Descripción',
                  hint: 'Contá brevemente qué servicios ofrecés',
                  controller: _aboutController,
                ),
              ],
              const SizedBox(height: 20),
              CustomPasswordField(
                label: 'Contraseña',
                hint: 'Al menos 8 caracteres',
                controller: _passwordController,
              ),
              const SizedBox(height: 20),
              TermsCheckbox(
                onChanged: (accepted) {
                  setState(() => _acceptedTerms = accepted);
                },
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                text: _isRegistering ? 'Creando cuenta...' : 'Registrarse',
                onPressed: _register,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('¿Ya tenés cuenta?'),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Iniciá sesión'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
