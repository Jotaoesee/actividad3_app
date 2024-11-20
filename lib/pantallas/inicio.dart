import 'package:actividad3_app/pantallas/registro.dart';
import 'package:actividad3_app/personalizable/boton/boton_personalizado.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Inicio extends StatefulWidget {
  const Inicio({Key? key}) : super(key: key);

  @override
  _InicioState createState() => _InicioState();
}


class _InicioState extends State<Inicio> {
  // Controladores para los campos de texto
  final TextEditingController controladorDeEmail = TextEditingController();
  final TextEditingController controladorDeContrasena = TextEditingController();

  // Función de validación
  void _validarYIniciarSesion() {
    final email = controladorDeEmail.text;
    final contrasena = controladorDeContrasena.text;

    // Validación del correo electrónico
    if (email.isEmpty || !RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$').hasMatch(email)) {
      _mostrarError("Por favor ingrese un correo electrónico válido.");
      return;
    }

    // Validación de la contraseña
    if (contrasena.isEmpty || contrasena.length < 6) {
      _mostrarError("La contraseña debe tener al menos 6 caracteres.");
      return;
    }

    // Si las validaciones pasan, puedes proceder con el inicio de sesión
    _mostrarExito("Iniciando sesión...");

    // Simula un retraso en el inicio de sesión para mostrar el mensaje
    Future.delayed(const Duration(seconds: 2), () {
      // Aquí se puede navegar a una nueva pantalla si el inicio de sesión es exitoso
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Registro()),
      );
    });
  }

  // Mostrar mensaje de error
  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  // Mostrar mensaje de éxito
  void _mostrarExito(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inicio de sesión"),
        backgroundColor: const Color.fromARGB(255, 28, 108, 178),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0D47A1),
              Color(0xFF1F77D3),
              Color(0xFF4AA3F3),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Bienvenido",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: controladorDeEmail,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Correo electrónico',
                  labelStyle: TextStyle(color: Colors.black87),
                  prefixIcon: Icon(Icons.email, color: Colors.grey),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              const SizedBox(height: 26),
              TextField(
                controller: controladorDeContrasena,
                obscureText: true,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Contraseña',
                  labelStyle: TextStyle(color: Colors.black87),
                  prefixIcon: Icon(Icons.lock, color: Colors.grey),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Botones de redes sociales
              const Text(
                "o inicia sesión con tus redes sociales",
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.facebook,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      // Acción para Facebook
                    },
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: const Icon(
                      FontAwesomeIcons.google,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      // Acción para Google
                    },
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: const FaIcon(
                      FontAwesomeIcons.twitter,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      // Acción para Twitter
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  BotonPersonalizado(
                      texto: "Iniciar Sesión",
                      icono: Icons.login,
                      alPresionar: _validarYIniciarSesion,
                  ),
                  BotonPersonalizado(
                    texto: " Registrar cuenta",
                    icono: Icons.app_registration,
                    alPresionar: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Registro()),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
