import 'package:flutter/material.dart';
import 'package:oficios/widgets/custom_password_field.dart';
import 'package:oficios/widgets/custom_text_field.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear cuenta')),
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  CustomTextField(
                    label: "Nombre Completo",
                    hint: "Ej. Lucas Gomez",
                  ),
                  CustomTextField(
                    label: "Correo electrónico",
                    hint: "Ej. johnDoe@gmail.com",
                  ),
                  CustomTextField(
                    label: "Número de teléfono",
                    hint: "Ej. 123-456-7890",
                  ),
                  CustomPasswordField(
                    label: "Contraseña",
                    hint: "Almenos 8 caracteres",
                  ),
                ],
              ),
            ),
          ]
        ),
      )
    );
  }
}