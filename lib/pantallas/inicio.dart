import 'package:actividad3_app/pantallas/home.dart';
import 'package:actividad3_app/pantallas/registro.dart';
import 'package:actividad3_app/personalizable/boton/boton_personalizado.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Inicio extends StatefulWidget {
  const Inicio({Key? key}) : super(key: key);

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  final TextEditingController controladorDeEmail = TextEditingController();
  final TextEditingController controladorDeContrasena = TextEditingController();

  bool esContrasenaVisible = false;
  bool _isLoading = false; // Indicador de carga para inicio de sesión

  // Expresión regular para validar el email
  final RegExp emailRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');

  // Función de validación y autenticación
  void _validarYIniciarSesion() async {
    final email = controladorDeEmail.text.trim();
    final contrasena = controladorDeContrasena.text.trim();

    if (email.isEmpty || !emailRegExp.hasMatch(email)) {
      _mostrarMensaje("Por favor ingrese un correo electrónico válido.");
      return;
    }

    if (contrasena.isEmpty || contrasena.length < 6) {
      _mostrarMensaje("La contraseña debe tener al menos 6 caracteres.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: contrasena,
      );
      _mostrarMensaje("Inicio de sesión exitoso. Bienvenido, ${credential.user?.email}.", isSuccess: true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    } on FirebaseAuthException catch (e) {
      _mostrarMensaje("Error: ${e.message}");
    } catch (e) {
      _mostrarMensaje("Ocurrió un error inesperado.");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Mostrar mensajes de error o éxito
  void _mostrarMensaje(String mensaje, {bool isSuccess = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
      ),
    );
  }

  // Widget para los campos de texto
  Widget _campoDeTexto({
    required TextEditingController controlador,
    required String labelText,
    required IconData icono,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controlador,
      obscureText: obscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.black87),
        prefixIcon: Icon(icono, color: Colors.grey),
        suffixIcon: suffixIcon,
        border: const OutlineInputBorder(),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inicio de sesión"),
        backgroundColor: const Color.fromARGB(255, 28, 108, 178),
      ),
      body: Stack(
        children: [
          Container(
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
                  _campoDeTexto(
                    controlador: controladorDeEmail,
                    labelText: 'Correo electrónico',
                    icono: Icons.email,
                  ),
                  const SizedBox(height: 26),
                  _campoDeTexto(
                    controlador: controladorDeContrasena,
                    labelText: 'Contraseña',
                    icono: Icons.lock,
                    obscureText: !esContrasenaVisible,
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
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.white, width: 2),
                        ),
                      ),
                      child: const Text(
                        "o inicia sesión con tus redes sociales",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
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
                        texto: "Registrar cuenta",
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
          // Indicador de carga en la parte inferior
          if (_isLoading)
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
