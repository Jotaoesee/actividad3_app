import 'package:actividad3_app/pantallas/home.dart';
import 'package:actividad3_app/pantallas/registro.dart';
import 'package:actividad3_app/personalizable/boton/boton_personalizado.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class InicioSesion extends StatefulWidget {
  const InicioSesion({Key? key}) : super(key: key);

  @override
  _InicioSesionState createState() => _InicioSesionState();
}

class _InicioSesionState extends State<InicioSesion> {
  final TextEditingController controladorDeEmail = TextEditingController();
  final TextEditingController controladorDeContrasena = TextEditingController();

  bool esContrasenaVisible = false;
  bool _isLoading = false; // Indicador de carga para inicio de sesión
  final _formKey = GlobalKey<FormState>();

  // Expresión regular para validar el email
  final RegExp emailRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');

  // Función de validación y autenticación
  void _validarYIniciarSesion() async {
    if(_formKey.currentState!.validate()){
      setState(() {
        _isLoading = true;
      });
      try {
        final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: controladorDeEmail.text,
          password: controladorDeContrasena.text,
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

  Widget _campoDeTexto({
    required TextEditingController controlador,
    required String labelText,
    required IconData icono,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
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
          borderSide: BorderSide(color: Color(0xFF0288D1)),
        ),
      ),
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inicio de sesión",
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0D47A1),
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
              child: Form(
                key: _formKey,
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
                      validator: (value) {
                        if(value == null || value.isEmpty) {
                          return "El email no puede estar vacío";
                        }
                        if (!emailRegExp.hasMatch(value)) {
                          return "Ingrese un email válido";
                        }
                        return null;
                      },
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
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            esContrasenaVisible = !esContrasenaVisible;
                          });
                        },
                      ),
                      validator: (value) {
                        if(value == null || value.isEmpty) {
                          return "La contraseña no puede estar vacía";
                        }
                        if (value.length < 6) {
                          return "La contraseña debe tener al menos 6 caracteres";
                        }
                        return null;
                      },
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
          ),
          if (_isLoading)
            Positioned(
              left: 0,
              right: 0,
              bottom: 100,
              child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                      const SizedBox(height: 10),
                      const Text("Iniciando Sesión...",
                          style: TextStyle(color: Colors.white, fontFamily: 'Roboto')),
                    ],
                  )
              ),
            ),
        ],
      ),
    );
  }
}