import "package:flutter/material.dart";
import "package:oficios/widgets/primary_button.dart";
import "package:oficios/widgets/role_selection_card.dart";

import "../widgets/logo.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 0 = ninguno, 1 = cliente, 2 = profesional
  int selectedRole = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 40,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Logo(label: "Bienvenido a OficiosYA"),
                    const SizedBox(height: 20),
                    const Text(
                      "Conectamos personas que necesitan un arreglo con profesionales calificados de la zona.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromARGB(255, 82, 82, 82),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 40),
                    RoleSelectionCard(
                      icon: Icons.search,
                      title: "Busco un oficio",
                      description: "Encuentra electricistas, plomeros y prestadores calificados.",
                      selected: selectedRole == 1,
                      onTap: () => setState(() => selectedRole = 1),
                    ),
                    const SizedBox(height: 16),
                    RoleSelectionCard(
                      icon: Icons.person,
                      title: "Soy un profesional",
                      description: "Me dedico a ofrecer servicios de reparación y mantenimiento.",
                      selected: selectedRole == 2,
                      onTap: () => setState(() => selectedRole = 2),
                    ),
                    const SizedBox(height: 40),
                    PrimaryButton(
                      text: "Continuar",
                      onPressed: () {
                        if (selectedRole == 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Por favor selecciona un rol para continuar.",
                              ),
                            ),
                          );
                          return;
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Esta sección estará disponible próximamente.",
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
