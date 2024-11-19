import 'package:actividad3_app/pantallas/inicio_sesion.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    InicioSesion inicioSesion = const InicioSesion();
    MaterialApp app =  const MaterialApp(title: "Mi primera App",);
    return app;
  }
}
