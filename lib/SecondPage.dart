import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Deuxième page"),
      ),
      body: const Center(
        child: Text("Bienvenue sur la deuxième page"),
      ),
    );
  }
}
