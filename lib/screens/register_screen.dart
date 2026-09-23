import 'package:flutter/material.dart';
import 'package:oficios/widgets/custom_password_field.dart';
import 'package:oficios/widgets/custom_text_field.dart';
import 'package:oficios/widgets/primary_button.dart';
import 'package:oficios/widgets/terms_checkbox.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool get _acceptedTerms => false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear cuenta'), titleTextStyle: const TextStyle( fontSize: 20, fontWeight: FontWeight.bold),),
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  CustomTextField(
                    label: "Nombre Completo",
                    hint: "Ej. Lucas Gomez",
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    label: "Correo electrónico",
                    hint: "Ej. johnDoe@gmail.com",
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    label: "Número de teléfono",
                    hint: "Ej. 123-456-7890",
                  ),
                  SizedBox(height: 20),
                  CustomPasswordField(
                    label: "Contraseña",
                    hint: "Almenos 8 caracteres",
                  ),
                  SizedBox(height: 20),
                  TermsCheckbox(
                    onChanged: (value) {
                      // Lógica para manejar el cambio del checkbox
                    },
                  ),
                  SizedBox(height: 20),
                  PrimaryButton(
                  text: 'Registrarse',
                    onPressed: () {
                      if (!_acceptedTerms) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Debes aceptar los términos y condiciones')),
                        );
                        return;
                      }
                      // Lógica de registro
                    },
                  ),
                   const SizedBox(height: 20),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("¿Ya tienes cuenta? "),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Inicia sesión', style: TextStyle(color: Color(0xFF2B66DF), fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                ],
              ),
            ),
          ]
        ),
      )
    );
  }
}