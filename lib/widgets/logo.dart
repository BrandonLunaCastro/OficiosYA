import "package:flutter/material.dart";

class Logo extends StatelessWidget {

  final String label;

  const Logo({
    super.key,
    required this.label
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children:[
        Image(
          image: AssetImage('assets/images/logo.jpeg'),
          width: 60,
          height: 60,
        ),
        Text(
          label,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}
