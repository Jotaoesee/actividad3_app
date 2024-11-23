import 'package:actividad3_app/pantallas/splash.dart';
import 'package:actividad3_app/personalizable/boton/boton_personalizado.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

  Future<void> _guardarImagenEnFirebase() async {
    try {
      // Inicializar Firebase
      await Firebase.initializeApp();

      // Obtener el uid del usuario autenticado
      User? usuario = FirebaseAuth.instance.currentUser;
      if (usuario == null) {
        print("Usuario no autenticado.");
        return;
      }
      String uid = usuario.uid;

      // Verificar si estamos en Web o móvil
      File? imagenFile;

      if (kIsWeb) {
        // Usar ImagePickerWeb para seleccionar imagen en Web
        final pickedBytes = await ImagePickerWeb.getImageAsBytes();
        if (pickedBytes != null) {
          imagenFile = File.fromRawPath(pickedBytes); // Convertir a File
        }
      } else {
        // Usar ImagePicker para seleccionar imagen en móvil
        final ImagePicker picker = ImagePicker();
        final XFile? imagenSeleccionada = await picker.pickImage(source: ImageSource.gallery);
        if (imagenSeleccionada != null) {
          imagenFile = File(imagenSeleccionada.path);
        }
      }

      if (imagenFile == null) {
        print("No se seleccionó ninguna imagen.");
        return;
      }

      // Crear una referencia al almacenamiento en Firebase con el uid del usuario
      final Reference storageRef = FirebaseStorage.instance.ref().child('imagenes/$uid.jpg');

      // Subir la imagen a Firebase Storage
      final UploadTask uploadTask = storageRef.putFile(imagenFile);

      // Esperar a que la carga termine
      final TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);

      // Obtener la URL de descarga de la imagen subida
      String downloadUrl = await snapshot.ref.getDownloadURL();

      print("Imagen subida con éxito. URL de descarga: $downloadUrl");

      // Guardar la URL de la imagen en Firestore
      await FirebaseFirestore.instance.collection('usuarios').doc(uid).update({
        'imagenPerfil': downloadUrl, // Guarda la URL de la imagen
      });

      // Actualizar la imagen localmente
      setState(() {
        _imagenPerfil = imagenFile;
      });

      // Mostrar un mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Imagen de perfil actualizada exitosamente")),
      );

    } catch (e) {
      print("Error al subir la imagen: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al subir la imagen: $e")),
      );
    }
  }

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
                        : (kIsWeb
                        ? FileImage(_imagenPerfil!) as ImageProvider
                        : Image.file(_imagenPerfil!) as ImageProvider),
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
                onGuardar(); // Guardar el cambio local
                _guardarImagenEnFirebase(); // Guardar en Firestore
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
                  _seleccionarImagen(); // Solo selecciona la imagen
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text("Tomar foto"),
                onTap: () {
                  Navigator.pop(context);
                  _tomarFoto(); // Solo toma la foto
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
      // Para Web, usa ImagePickerWeb para seleccionar imagen
      try {
        final pickedBytes = await ImagePickerWeb.getImageAsBytes();
        if (pickedBytes != null) {
          setState(() {
            _imagenPerfil = File.fromRawPath(pickedBytes);
          });
        } else {
          print("No se seleccionó ninguna imagen.");
        }
      } catch (e) {
        print("Error al seleccionar la imagen: $e");
      }
    } else {
      // Para móvil
      final ImagePicker _picker = ImagePicker();
      final XFile? imagen = await _picker.pickImage(source: ImageSource.gallery);
      if (imagen != null) {
        setState(() {
          _imagenPerfil = File(imagen.path);
        });
      }
    }
    _guardarImagenEnFirebase();
  }


// Método para tomar foto con la cámara
  Future<void> _tomarFoto() async {
    if (kIsWeb) {
      // Para Web, usa ImagePickerWeb para tomar foto
      final pickedBytes = await ImagePickerWeb.getImageAsBytes();
      if (pickedBytes != null) {
        setState(() {
          _imagenPerfil = File.fromRawPath(pickedBytes); // Asigna la foto tomada como File
        });
      }
    } else {
      // Para móvil, usa ImagePicker para tomar foto
      final ImagePicker _picker = ImagePicker();
      final XFile? imagen = await _picker.pickImage(source: ImageSource.camera);
      if (imagen != null) {
        setState(() {
          _imagenPerfil = File(imagen.path); // Asigna la foto tomada como File
        });
      }
    }
    _guardarImagenEnFirebase(); // Subir la imagen después de tomarla
  }

}