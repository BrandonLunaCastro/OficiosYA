import 'package:flutter/material.dart';

class HomeTopBar extends StatelessWidget {
  final String? location;
  final String initials;
  final VoidCallback onTap;

  const HomeTopBar({
    super.key,
    this.location,
    required this.initials,
    required this.onTap,
  });

  static const String _defaultLocation = 'Mendoza Capital';

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF2B66DF);
    final displayLocation = (location == null || location!.trim().isEmpty)
        ? _defaultLocation
        : location!;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on_outlined, color: primaryColor, size: 20),
                const SizedBox(width: 6),
                Text(
                  displayLocation,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
            CircleAvatar(
              radius: 16,
              backgroundColor: primaryColor,
              child: Text(
                initials,
                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}