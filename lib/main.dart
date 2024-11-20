import 'package:actividad3_app/pantallas/inicio.dart';
import 'package:actividad3_app/pantallas/registro.dart';
import 'package:flutter/material.dart';
import 'package:actividad3_app/pantallas/splash.dart';

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
      initialRoute: '/splash', // Ruta inicial ahora es la pantalla Splash
      routes: {
        '/splash': (context) =>  SplashScreen(),
        '/': (context) => const Inicio(),
        '/registro': (context) => Registro(),
      },
    );
  }
}
