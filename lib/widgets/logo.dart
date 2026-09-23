import "package:flutter/material.dart";

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Image(
          image: AssetImage('assets/images/logo.jpeg'),
          width: 60,
          height: 60,
        ),
        Text(
          'OficiosYA',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}
