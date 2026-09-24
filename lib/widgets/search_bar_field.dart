import 'package:flutter/material.dart';

class SearchBarField extends StatelessWidget {
  final String hintText;
  final VoidCallback? onTap;

  const SearchBarField({
    super.key,
    this.hintText = '¿Qué servicio necesitas hoy?',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: Colors.grey.shade600),
            const SizedBox(width: 10),
            Text(hintText, style: TextStyle(color: Colors.grey.shade600, fontSize: 15)),
          ],
        ),
      ),
    );
  }
}