import 'package:flutter/material.dart';
import 'package:oficios/models/user_profile.dart';
import 'package:oficios/routes/app_routes.dart';
import 'package:oficios/widgets/custom_text_field.dart';
import 'package:oficios/widgets/primary_button.dart';
import 'package:oficios/widgets/profile_avatar_picker.dart';

class EditProfileClientScreen extends StatefulWidget {
  const EditProfileClientScreen({super.key});

  @override
  State<EditProfileClientScreen> createState() =>
      _EditProfileClientScreenState();
}

class _EditProfileClientScreenState extends State<EditProfileClientScreen> {
  final _nameController = TextEditingController(
    text: UserProfile.instance.name,
  );
  final _emailController = TextEditingController(
    text: UserProfile.instance.email,
  );
  final _phoneController = TextEditingController(
    text: UserProfile.instance.phone,
  );
  final _locationController = TextEditingController(
    text: UserProfile.instance.location,
  );

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _guardarCambios() {
    UserProfile.instance.name = _nameController.text;
    UserProfile.instance.email = _emailController.text;
    UserProfile.instance.phone = _phoneController.text;
    UserProfile.instance.location = _locationController.text;

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
              const Center(child: ProfileAvatarPicker(initials: 'LG')),
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
