import 'package:flutter/material.dart';

class Registro extends StatefulWidget {
  @override
  _RegistroState createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  final TextEditingController controladorEmail = TextEditingController();
  final TextEditingController controladorContrasena = TextEditingController();
  final TextEditingController controladorConfirmarContrasena = TextEditingController();

  bool esPresionado = false; // Para animar el boton
  bool esContrasenaVisible = false; // Para controlar la visibilidad de la contrasena

  void validarFormulario(BuildContext contexto) {
    String email = controladorEmail.text.trim();
    String contrasena = controladorContrasena.text.trim();
    String confirmarContrasena = controladorConfirmarContrasena.text.trim();

    if (email.isEmpty || contrasena.isEmpty || confirmarContrasena.isEmpty) {
      mostrarMensaje(contexto, "Por favor, completa todos los campos.");
      return;
    }

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      mostrarMensaje(contexto, "Por favor, ingresa un correo valido.");
      return;
    }

    if (contrasena != confirmarContrasena) {
      mostrarMensaje(contexto, "Las contraseñas no coinciden.");
      return;
    }

    mostrarMensaje(contexto, "Registro completado con exito.");
  }

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
              TextField(
                controller: controladorEmail,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Correo electronico',
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
              const SizedBox(height: 20),
              TextField(
                controller: controladorContrasena,
                obscureText: !esContrasenaVisible,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Contraseña',
                  labelStyle: const TextStyle(color: Colors.black87),
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
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: controladorConfirmarContrasena,
                obscureText: !esContrasenaVisible,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Confirmar Contraseña',
                  labelStyle: const TextStyle(color: Colors.black87),
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
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTapDown: (_) {
                  setState(() {
                    esPresionado = true;
                  });
                },
                onTapUp: (_) {
                  setState(() {
                    esPresionado = false;
                  });
                  validarFormulario(contexto);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  padding: EdgeInsets.symmetric(
                    horizontal: esPresionado ? 25 : 20,
                    vertical: esPresionado ? 12 : 15,
                  ),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 28, 108, 178),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: esPresionado
                        ? []
                        : [
                      const BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Text(
                    "Registrarse",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
