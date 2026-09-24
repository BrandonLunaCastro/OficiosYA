import 'package:flutter/material.dart';
import 'package:oficios/widgets/custom_text_field.dart';
import 'package:oficios/widgets/primary_button.dart';
import 'package:oficios/widgets/profile_avatar_picker.dart';
import 'package:oficios/widgets/section_title.dart';

class EditProfileProfessionalScreen extends StatelessWidget {
  const EditProfileProfessionalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil profesional')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Center(
                child: ProfileAvatarPicker(
                  initials: 'CR',
                  label: 'Cambiar foto profesional',
                ),
              ),
              const SizedBox(height: 24),
              const SectionTitle(title: 'Datos personales'),
              const SizedBox(height: 16),
              const CustomTextField(
                label: "Nombre completo",
                hint: "Ej. Carlos Rodríguez",
              ),
              const SizedBox(height: 20),
              const CustomTextField(
                label: "Correo electrónico",
                hint: "ejemplo@correo.com",
                keyBoardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              const CustomTextField(
                label: "Teléfono de contacto",
                hint: "Ej. +54 9 261 123456",
                keyBoardType: TextInputType.phone,
              ),
              const SizedBox(height: 24),
              const SectionTitle(
                title: 'Información profesional',
                verified: true,
              ),
              const SizedBox(height: 16),
              const CustomTextField(
                label: "Oficio / Especialidad principal",
                hint: "Ej. Plomería y Gasista",
              ),
              const SizedBox(height: 20),
              const CustomTextField(
                label: "Años de experiencia",
                hint: "Ej. 10 años",
                keyBoardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              const CustomTextField(
                label: "Zona de cobertura",
                hint: "Ej. Mendoza Capital y alrededores",
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Sobre mí",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Hola, soy... Ofrezco servicios de...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              PrimaryButton(
                text: 'Guardar perfil profesional',
                onPressed: () {
                  // Lógica para guardar y navegar al home del profesional
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
