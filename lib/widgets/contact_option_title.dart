import 'package:flutter/material.dart';

class ContactOptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String buttonText;
  final VoidCallback onPressed;

  const ContactOptionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF2B66DF);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade600, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: primaryColor,
              side: const BorderSide(color: primaryColor),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }
}