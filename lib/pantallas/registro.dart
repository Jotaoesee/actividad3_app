import 'package:flutter/material.dart';

class Registro extends StatelessWidget {
  const Registro({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registro"),
        backgroundColor: const Color.fromARGB(255, 28, 108, 178),
      ),
      body: Container(
        color: const Color.fromARGB(255, 122, 193, 255),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Crear cuenta",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              )
            ],

          ),
        )
      ),
    );
  }
}
