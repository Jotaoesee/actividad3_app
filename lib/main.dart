import 'package:actividad3_app/pantallas/ajuste.dart';
import 'package:actividad3_app/pantallas/home.dart';
import 'package:actividad3_app/pantallas/inicio.dart';
import 'package:actividad3_app/pantallas/inicio_sesion.dart';
import 'package:actividad3_app/pantallas/perfil_usuario.dart';
import 'package:actividad3_app/pantallas/registro.dart';
import 'package:actividad3_app/pantallas/splash.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        '/splash': (context) => Splash(),
        '/inicio': (context) => const InicioSesion(),
        '/registro': (context) => Registro(),
        '/home': (context) => const Home(),
        '/ajuste': (context) => const Ajuste(),
        '/perfilUsuario': (context) =>  const PerfilUsuario(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
