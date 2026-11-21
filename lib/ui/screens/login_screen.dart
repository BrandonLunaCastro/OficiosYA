import 'package:flutter/material.dart';
import 'package:oficios/data/repositories/mock_auth_repository.dart';
import 'package:oficios/data/repositories/professional_profile_repository.dart';
import 'package:oficios/data/repositories/provider_contact_repository.dart';
import 'package:oficios/data/repositories/user_profile_repository.dart';
import 'package:oficios/routes/app_routes.dart';
import 'package:oficios/ui/widgets/custom_password_field.dart';
import 'package:oficios/ui/widgets/custom_text_field.dart';
import 'package:oficios/ui/widgets/logo.dart';
import 'package:oficios/ui/widgets/primary_button.dart';

class Login extends StatefulWidget {
  const Login({
    super.key,
    required this.authRepository,
    required this.clientProfileRepository,
    required this.professionalProfileRepository,
    required this.providerContactRepository,
  });

  final MockAuthRepository authRepository;
  final UserProfileRepository clientProfileRepository;
  final ProfessionalProfileRepository professionalProfileRepository;
  final ProviderContactRepository providerContactRepository;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool _isSigningIn = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (_isSigningIn) return;
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresá tu correo y contraseña.')),
      );
      return;
    }

    setState(() => _isSigningIn = true);
    try {
      final account = await widget.authRepository.signIn(
        email: _emailController.text,
        password: _passwordController.text,
      );

      late final String destination;
      switch (account.role) {
        case MockAccountRole.client:
          if (widget.clientProfileRepository.getProfile().id.isEmpty) {
            widget.clientProfileRepository.saveProfile(account.clientProfile!);
          }
          destination = AppRoutes.clientHome;
          break;
        case MockAccountRole.professional:
          final currentProfile = await widget.professionalProfileRepository
              .getProfile();
          if (currentProfile.name.trim().isEmpty) {
            await widget.professionalProfileRepository.updateProfile(
              account.professionalProfile!,
            );
          }
          final currentContact = await widget.providerContactRepository
              .getContactInfo();
          if (currentContact.phone.trim().isEmpty ||
              currentContact.email.trim().isEmpty) {
            await widget.providerContactRepository.updateContactInfo(
              account.providerContactInfo!,
            );
          }
          destination = AppRoutes.professionalProfile;
          break;
      }

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, destination);
    } on MockAuthException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo iniciar sesión: $error')),
      );
    } finally {
      if (mounted) setState(() => _isSigningIn = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                //importamos widget del logo
                Logo(label: 'OficiosYA'),
                const SizedBox(height: 50),
                const Text(
                  '¡Hola de nuevo!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                ),
                const Text(
                  "Ingresa tus datos para continuar",
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),
                //importamos widget del custom text field
                CustomTextField(
                  label: "Correo electrónico",
                  hint: "johnDoe@gmail.com",
                  controller: _emailController,
                  keyBoardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 20),
                CustomPasswordField(
                  label: "Contraseña",
                  hint: "Almenos 8 caracteres",
                  controller: _passwordController,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      '¿Olvidaste tu contraseña?',
                      style: TextStyle(
                        color: Color(0xFF2B66DF),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                PrimaryButton(
                  text: _isSigningIn ? 'Ingresando...' : 'Iniciar sesión',
                  onPressed: _signIn,
                ),

                const SizedBox(height: 20),
                _DemoAccountsCard(
                  onUseClient: () =>
                      _fillDemoAccount('cliente@oficiosya.com', 'Cliente123'),
                  onUseProfessional: () => _fillDemoAccount(
                    'prestador@oficiosya.com',
                    'Prestador123',
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("¿No tienes una cuenta?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.register);
                      },
                      child: const Text(
                        'Regístrate',
                        style: TextStyle(
                          color: Color(0xFF2B66DF),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _fillDemoAccount(String email, String password) {
    setState(() {
      _emailController.text = email;
      _passwordController.text = password;
    });
  }
}

class _DemoAccountsCard extends StatelessWidget {
  const _DemoAccountsCard({
    required this.onUseClient,
    required this.onUseProfessional,
  });

  final VoidCallback onUseClient;
  final VoidCallback onUseProfessional;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6FA),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE7EAF0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cuentas de prueba',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 8),
          _DemoAccountRow(
            role: 'Cliente',
            email: 'cliente@oficiosya.com',
            password: 'Cliente123',
            onUse: onUseClient,
          ),
          const Divider(height: 16),
          _DemoAccountRow(
            role: 'Prestador',
            email: 'prestador@oficiosya.com',
            password: 'Prestador123',
            onUse: onUseProfessional,
          ),
        ],
      ),
    );
  }
}

class _DemoAccountRow extends StatelessWidget {
  const _DemoAccountRow({
    required this.role,
    required this.email,
    required this.password,
    required this.onUse,
  });

  final String role;
  final String email;
  final String password;
  final VoidCallback onUse;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                role,
                style: const TextStyle(
                  color: Color(0xFF2B66DF),
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              Text(email, style: const TextStyle(fontSize: 11)),
              Text(
                'Contraseña: $password',
                style: const TextStyle(fontSize: 11),
              ),
            ],
          ),
        ),
        TextButton(onPressed: onUse, child: const Text('Usar')),
      ],
    );
  }
}
