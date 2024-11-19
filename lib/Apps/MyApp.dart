import 'package:actividad3_app/pantallas/inicio.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Inicio inicioSesion = const Inicio();
    MaterialApp app =  const MaterialApp(title: "Mi primera App",);
    return app;
  }
}
