import 'package:flutter/material.dart';

class ProviderBottomNav extends StatelessWidget {
  const ProviderBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF2B66DF),
      unselectedItemColor: Colors.blueGrey.shade300,
      selectedFontSize: 10,
      unselectedFontSize: 10,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Mi perfil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.build_outlined),
          label: 'Servicios',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment_outlined),
          label: 'Pedidos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.location_on_outlined),
          label: 'Contacto',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.star_border),
          label: 'Reseñas',
        ),
      ],
    );
  }
}
