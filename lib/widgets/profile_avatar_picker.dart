import 'package:flutter/material.dart';

class ProfileAvatarPicker extends StatelessWidget {
  final String initials;
  final String label;
  final VoidCallback? onTap;

  const ProfileAvatarPicker({
    super.key,
    required this.initials,
    this.label = "Cambiar foto de perfil",
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF2B66DF);

    return Column(
      children: [
        CircleAvatar(
          radius: 36,
          backgroundColor: primaryColor,
          child: Text(
            initials,
            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: onTap,
          child: Text(
            label,
            style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}