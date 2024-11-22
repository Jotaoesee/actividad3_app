import 'package:actividad3_app/personalizable/boton/boton_personalizado.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Registro extends StatefulWidget {
  @override
  _RegistroState createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  final TextEditingController controladorEmail = TextEditingController();
  final TextEditingController controladorContrasena = TextEditingController();
  final TextEditingController controladorConfirmarContrasena = TextEditingController();

  bool esPresionado = false;
  bool esContrasenaVisible = false;

  // Validar los campos del formulario antes de registrar
  void validarFormulario(BuildContext contexto) {
    String email = controladorEmail.text.trim();
    String contrasena = controladorContrasena.text.trim();
    String confirmarContrasena = controladorConfirmarContrasena.text.trim();

    // Verificar que los campos no estén vacíos
    if (email.isEmpty || contrasena.isEmpty || confirmarContrasena.isEmpty) {
      mostrarMensaje(contexto, "Por favor, completa todos los campos.");
      return;
    }

    // Verificar que el correo sea válido
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      mostrarMensaje(contexto, "Por favor, ingresa un correo valido.");
      return;
    }

    // Verificar que las contraseñas coincidan
    if (contrasena != confirmarContrasena) {
      mostrarMensaje(contexto, "Las contraseñas no coinciden.");
      return;
    }

    // Si todo es correcto, intentar registrar al usuario
    registrarUsuario();
  }

  // Registrar al usuario con Firebase
  void registrarUsuario() async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: controladorEmail.text,
        password: controladorContrasena.text,
      );
      mostrarMensaje(context, "Registro completado con éxito.");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        mostrarMensaje(context, "Este correo ya está en uso.");
      } else {
        mostrarMensaje(context, "Error: ${e.message}");
      }
    }
  }

  // Mostrar mensajes en pantalla
  void mostrarMensaje(BuildContext contexto, String mensaje) {
    ScaffoldMessenger.of(contexto).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext contexto) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registro"),
        backgroundColor: const Color(0xFF0D47A1), // Azul más oscuro
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0D47A1), // Azul oscuro
              Color(0xFF1F77D3), // Azul medio
              Color(0xFF4AA3F3), // Azul claro
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
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
              ),
              const SizedBox(height: 20),
              // Campo de correo electrónico
              TextField(
                controller: controladorEmail,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Correo electronico',
                  labelStyle: TextStyle(color: Color(0xFF0288D1)),
                  prefixIcon: Icon(Icons.email, color: Colors.grey),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF0288D1)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Campo de contraseña
              TextField(
                controller: controladorContrasena,
                obscureText: !esContrasenaVisible,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Contraseña',
                  labelStyle: const TextStyle(color: Color(0xFF0288D1)),
                  prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                  suffixIcon: IconButton(
                    icon: Icon(
                      esContrasenaVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        esContrasenaVisible = !esContrasenaVisible;
                      });
                    },
                  ),
                  border: const OutlineInputBorder(),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF0288D1)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Campo de confirmar contraseña
              TextField(
                controller: controladorConfirmarContrasena,
                obscureText: !esContrasenaVisible,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Confirmar Contraseña',
                  labelStyle: const TextStyle(color: Color(0xFF0288D1)),
                  prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                  suffixIcon: IconButton(
                    icon: Icon(
                      esContrasenaVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        esContrasenaVisible = !esContrasenaVisible;
                      });
                    },
                  ),
                  border: const OutlineInputBorder(),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF0288D1)),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Sección de iconos de redes sociales con líneas
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.white, width: 2),
                    ),
                  ),
                  child: const Text(
                    "o con tus redes sociales",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Iconos de redes sociales
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.facebook,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: const Icon(
                      FontAwesomeIcons.google,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: const FaIcon(
                      FontAwesomeIcons.twitter,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Botón de registrarse
              BotonPersonalizado(
                texto: "Registrarse",
                icono: Icons.person_add,
                alPresionar: () {
                  // Validar antes de registrar
                  validarFormulario(contexto);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
