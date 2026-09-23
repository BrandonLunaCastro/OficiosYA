import "package:flutter/material.dart";
import "../widgets/logo.dart";

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Center(
          child:SingleChildScrollView(
             child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Logo(),
                SizedBox(height: 20),
              ],
          ),
        ),
      ),
      )
    );
  }
}
