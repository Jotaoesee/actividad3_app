import 'package:actividad3_app/pantallas/inicio.dart';
import 'package:flutter/material.dart';
import 'package:actividad3_app/pantallas/registro.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/', // Establecer la ruta inicial
      routes: {
        '/': (context) => const Inicio(), // Pantalla de inicio de sesión
        '/registro': (context) => const Registro(), // Pantalla de registro
      },
    );
  }
}
