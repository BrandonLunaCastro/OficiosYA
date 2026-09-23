import 'package:flutter/material.dart';
import 'package:oficios/screens/home_screen.dart';
import 'package:oficios/screens/register_screen.dart';
import 'package:oficios/widgets/custom_password_field.dart';
import 'package:oficios/widgets/custom_text_field.dart';
import 'package:oficios/widgets/logo.dart';
import 'package:oficios/widgets/primary_button.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _obscurePassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
      child:Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            //importamos widget del logo
            Logo(label: 'OficiosYA',),
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
            ),    

            const SizedBox(height: 20),
            CustomPasswordField(
              label: "Contraseña",
              hint: "Almenos 8 caracteres",
            ),
            Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text('¿Olvidaste tu contraseña?',
                        style: TextStyle(color: Color(0xFF2B66DF), fontWeight: FontWeight.bold)),
                  ),
                ),

            const SizedBox(height: 20),
            PrimaryButton(
              text: 'Iniciar sesión',
              onPressed: () {
                // logica provisoria 
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
              },),
          
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("¿No tienes una cuenta?"),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Register()),
                    );
                  },
                  child: const Text('Regístrate', style: TextStyle(color: Color(0xFF2B66DF), fontWeight: FontWeight.bold),),
                ),
              ],
            ),
          ],
        ),
      ),
    )
    )
    );
  }
}