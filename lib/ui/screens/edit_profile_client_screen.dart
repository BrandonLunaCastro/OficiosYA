import 'package:flutter/material.dart';
import 'package:oficios/data/repositories/user_profile_repository.dart';
import 'package:oficios/routes/app_routes.dart';
import 'package:oficios/ui/widgets/custom_text_field.dart';
import 'package:oficios/ui/widgets/primary_button.dart';
import 'package:oficios/ui/widgets/profile_avatar_picker.dart';

class EditProfileClientScreen extends StatefulWidget {
  const EditProfileClientScreen({super.key, required this.profileRepository});

  final UserProfileRepository profileRepository;

  @override
  State<EditProfileClientScreen> createState() =>
      _EditProfileClientScreenState();
}

class _EditProfileClientScreenState extends State<EditProfileClientScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    final profile = widget.profileRepository.getProfile();
    _nameController = TextEditingController(text: profile.name);
    _emailController = TextEditingController(text: profile.email);
    _phoneController = TextEditingController(text: profile.phone);
    _locationController = TextEditingController(text: profile.location);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _guardarCambios() {
    final profile = widget.profileRepository.getProfile();
    widget.profileRepository.saveProfile(
      profile.copyWith(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        location: _locationController.text,
      ),
    );

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.clientHome,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar perfil')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Center(
                child: ProfileAvatarPicker(
                  initials: widget.profileRepository.getProfile().initials,
                ),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: "Nombre completo",
                hint: "Ej. Lucas Gómez",
                controller: _nameController,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: "Correo electrónico",
                hint: "ejemplo@correo.com",
                controller: _emailController,
                keyBoardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: "Teléfono de contacto",
                hint: "Ej. +54 9 261 123456",
                controller: _phoneController,
                keyBoardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: "Ubicación",
                hint: "Ej. Mendoza Capital, Mendoza",
                controller: _locationController,
              ),
              const SizedBox(height: 30),
              PrimaryButton(
                text: 'Guardar cambios',
                onPressed: _guardarCambios,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
