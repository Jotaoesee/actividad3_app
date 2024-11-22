import 'package:actividad3_app/pantallas/splash.dart';
import 'package:actividad3_app/personalizable/boton/boton_personalizado.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

class PerfilUsuario extends StatefulWidget {
  const PerfilUsuario({Key? key}) : super(key: key);

  @override
  _PerfilUsuarioState createState() => _PerfilUsuarioState();
}

class _PerfilUsuarioState extends State<PerfilUsuario> {
  String _nombre = "Nombre de Usuario";
  String _apellido = "Apellido de Usuario";
  String _telefono = "+123 456 789";
  String _ciudad = "Ciudad, País";
  String _fechaNacimiento = "01/01/1990";

  File? _imagenPerfil; // Variable para almacenar la imagen de perfil

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _ciudadController = TextEditingController();
  final TextEditingController _fechaNacimientoController = TextEditingController();

  final Map<String, List<Color>> esquemasDeColor = {
    'Azul': [Color(0xFF0D47A1), Color(0xFF1F77D3), Color(0xFF4AA3F3)],
    'Verde': [Color(0xFF1B5E20), Color(0xFF4CAF50), Color(0xFF81C784)],
    'Rojo': [Color(0xFFB71C1C), Color(0xFFE53935), Color(0xFFFFCDD2)],
    'Amarillo': [Color(0xFFF57F17), Color(0xFFFFEB3B), Color(0xFFFFF176)],
  };

  String _esquemaColor = 'Azul';

  @override
  Widget build(BuildContext context) {
    final Color fondoColor = esquemasDeColor[_esquemaColor]![0];
    final Color textoColor = Colors.white;

    return Theme(
      data: ThemeData(
        primaryColor: fondoColor,
        textTheme: TextTheme(bodyMedium: TextStyle(color: textoColor)),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Perfil del Usuario"),
          backgroundColor: fondoColor,
        ),
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: esquemasDeColor[_esquemaColor]!,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  // Foto de perfil
                  CircleAvatar(
                    radius: 70,
                    backgroundImage: _imagenPerfil == null
                        ? const NetworkImage('https://via.placeholder.com/150')
                        : FileImage(_imagenPerfil!) as ImageProvider,
                  ),
                  IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: () {
                      _mostrarOpcionesImagen();
                    },
                  ),
                  const SizedBox(height: 20),
                  // Nombre del usuario
                  Text(
                    _nombre,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "usuario@correo.com",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Información adicional en Card con bordes redondeados
                  _crearCard("Nombre", _nombre, _nombreController, (nuevoValor) {
                    setState(() {
                      _nombre = nuevoValor;
                    });
                  }),
                  _crearCard("Apellido", _apellido, _apellidoController, (nuevoValor) {
                    setState(() {
                      _apellido = nuevoValor;
                    });
                  }),
                  _crearCard("Fecha de nacimiento", _fechaNacimiento, _fechaNacimientoController, (nuevoValor) {
                    setState(() {
                      _fechaNacimiento = nuevoValor;
                    });
                  }),
                  _crearCard("Teléfono", _telefono, _telefonoController, (nuevoValor) {
                    setState(() {
                      _telefono = nuevoValor;
                    });
                  }),
                  _crearCard("Ciudad", _ciudad, _ciudadController, (nuevoValor) {
                    setState(() {
                      _ciudad = nuevoValor;
                    });
                  }),

                  const SizedBox(height: 5),  // Ajusta este espacio según lo necesites
                  // Botón de cerrar sesión
                  BotonPersonalizado(
                    texto: "Cerrar sesión",
                    icono: Icons.logout,
                    alPresionar: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Splash())
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),

      ),
    );
  }


  // Método para crear las cards de cada campo editable
  Widget _crearCard(String titulo, String campo, TextEditingController controlador, Function(String) onGuardar) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: ListTile(
        leading: const Icon(Icons.edit),
        title: Text(titulo),
        subtitle: Text(campo),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            _mostrarDialogoEdicion(titulo, campo, controlador, () {
              onGuardar(controlador.text);
            });
          },
        ),
      ),
    );
  }

  // Método para mostrar el cuadro de diálogo de edición
  void _mostrarDialogoEdicion(
      String titulo,
      String campo,
      TextEditingController controlador,
      VoidCallback onGuardar) {

    controlador.text = campo;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Editar $titulo"),
          content: TextField(
            controller: controlador,
            decoration: InputDecoration(hintText: "Ingrese $titulo"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cerrar el diálogo sin guardar
              },
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                onGuardar(); // Guardar el cambio
                Navigator.pop(context); // Cerrar el diálogo
              },
              child: const Text("Guardar"),
            ),
          ],
        );
      },
    );
  }

  // Método para mostrar las opciones de imagen
  void _mostrarOpcionesImagen() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Selecciona una opción"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text("Seleccionar de la galería"),
                onTap: () {
                  Navigator.pop(context);
                  _seleccionarImagen(); // Llamar a seleccionar imagen
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text("Tomar foto"),
                onTap: () {
                  Navigator.pop(context);
                  _tomarFoto(); // Llamar a tomar foto
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Método para seleccionar imagen de la galería
  Future<void> _seleccionarImagen() async {
    if (kIsWeb) {
      // Para web, usar ImagePickerWeb para seleccionar imagen de la galería
      final pickedFile = await ImagePickerWeb.getImageAsFile();
      if (pickedFile != null) {
        setState(() {
          _imagenPerfil = pickedFile as File?; // Asigna la imagen seleccionada
        });
      }
    } else {
      // Para móvil, usar ImagePicker para seleccionar imagen de la galería
      final ImagePicker _picker = ImagePicker();
      final XFile? imagen = await _picker.pickImage(source: ImageSource.gallery);
      if (imagen != null) {
        setState(() {
          _imagenPerfil = File(imagen.path); // Asigna la imagen seleccionada
        });
      }
    }
  }

  // Método para tomar foto con la cámara
  Future<void> _tomarFoto() async {
    if (kIsWeb) {
      // Para web, usar ImagePickerWeb para tomar foto
      final pickedFile = await ImagePickerWeb.getImageAsFile();
      if (pickedFile != null) {
        setState(() {
          _imagenPerfil = pickedFile as File?; // Asigna la foto tomada
        });
      }
    } else {
      // Para móvil, usar ImagePicker para tomar foto
      final ImagePicker _picker = ImagePicker();
      final XFile? imagen = await _picker.pickImage(source: ImageSource.camera);
      if (imagen != null) {
        setState(() {
          _imagenPerfil = File(imagen.path); // Asigna la foto tomada
        });
      }
    }
  }
}