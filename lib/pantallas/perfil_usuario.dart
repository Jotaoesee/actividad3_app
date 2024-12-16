import 'package:actividad3_app/pantallas/splash.dart';
import 'package:actividad3_app/personalizable/boton/boton_personalizado.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../clases/firebase_admin.dart';

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
  final _formKey = GlobalKey<FormState>();


  Uint8List? _imagenPerfilBytes; // Variable para almacenar la imagen de perfil como bytes
  bool _isLoading = false;

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
  User? _usuario; // Para almacenar el usuario autenticado

  @override
  void initState() {
    super.initState();

    // Obtén el usuario autenticado
    _usuario = FirebaseAuth.instance.currentUser;

    // Carga los datos del usuario
    _cargarDatosUsuario();

  }


// Método para cargar los datos del usuario desde Firebase
  Future<void> _cargarDatosUsuario() async {
    try {
      FirebaseAdmin firebaseAdmin = FirebaseAdmin();
      Map<String, dynamic> usuarioData = await firebaseAdmin.obtenerUsuario();  // Asegúrate de tener este método en tu FirebaseAdmin
      if(mounted){
        setState(() {
          _nombre = usuarioData['nombre'] ?? 'Nombre de Usuario';
          _apellido = usuarioData['apellido'] ?? 'Apellido de Usuario';
          _telefono = usuarioData['telefono'] ?? '+123 456 789';
          _ciudad = usuarioData['ciudad'] ?? 'Ciudad, País';
          _fechaNacimiento = usuarioData['fechaNacimiento'] ?? '01/01/1990';
        });
      }

    } catch (e) {
      print("Error al cargar los datos del usuario: $e");
    }
  }


  Future<void> _guardarDatosEnFirebase() async {
    if(_formKey.currentState!.validate()){
      setState(() {
        _isLoading = true;
      });
      try {
        FirebaseAdmin firebaseAdmin = FirebaseAdmin();
        // Actualiza el mapa con los datos del usuario, incluyendo el nombre
        Map<String, dynamic> usuarioData = {
          'nombre': _nombre,  // Aquí guardamos el valor de _nombre actualizado
          'apellido': _apellido,
          'telefono': _telefono,
          'ciudad': _ciudad,
          'fechaNacimiento': _fechaNacimiento,
        };
        // Guarda los datos en Firestore
        await firebaseAdmin.guardarUsuario(usuarioData);
        // Muestra un mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Datos guardados exitosamente")),
        );
        print("Datos guardados en Firebase: $usuarioData");
      } catch (e) {
        print("Error al guardar datos en Firebase: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al guardar datos: $e")),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }


  Future<void> _subirImagenYGuardarUrl() async {
    if (_imagenPerfilBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No se ha seleccionado ninguna imagen")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });
    try {
      FirebaseAdmin firebaseAdmin = FirebaseAdmin();
      await firebaseAdmin.subirImagenPerfilBytes(_imagenPerfilBytes!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Imagen subida exitosamente")),
      );
    } catch (e) {
      print("Error al subir imagen: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al subir imagen: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color fondoColor = esquemasDeColor[_esquemaColor]![0];
    final Color textoColor = Colors.white;

    return Theme(
      data: ThemeData(
        primaryColor: fondoColor,
        textTheme: TextTheme(bodyMedium: TextStyle(color: textoColor, fontFamily: 'Roboto')),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Perfil del Usuario", style: TextStyle(color: Colors.white),),
          backgroundColor: fondoColor,
        ),
        body: Stack(
            children:[
              SingleChildScrollView(
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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          // Método para mostrar la imagen de perfil, utilizando MemoryImage en Web
                          ClipOval(
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.white,
                                      width: 3
                                  )
                              ),
                              child: CircleAvatar(
                                radius: 70,
                                backgroundImage: _imagenPerfilBytes == null
                                    ? const NetworkImage('https://via.placeholder.com/150')
                                    : (kIsWeb
                                    ? MemoryImage(_imagenPerfilBytes!)
                                    : _imagenPerfilBytes == null ? null: FileImage(File(_imagenPerfilBytes!.join(""))) as ImageProvider<Object>),
                              ),
                            ),
                          ),

                          IconButton(
                            icon: const Icon(Icons.camera_alt, color: Colors.white,),
                            onPressed: () {
                              _mostrarOpcionesImagen();
                            },
                          ),
                          const SizedBox(height: 20),
                          // Nombre del usuario y correo
                          Text(
                            _nombre,
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Roboto'
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _usuario?.email ?? "usuario@correo.com", // Correo si existe, sino un valor por defecto
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontFamily: 'Roboto'
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

                          const SizedBox(height: 5),
                          // Botón de cerrar sesión
                          BotonPersonalizado(
                            texto: "Cerrar sesión",
                            icono: FontAwesomeIcons.signOutAlt,
                            alPresionar: () {
                              FirebaseAuth.instance.signOut(); // Cierra sesión en Firebase
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => Splash()),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if(_isLoading)
                const Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Center(child: CircularProgressIndicator(color: Colors.white,))
                ),
            ]
        ),
      ),
    );
  }

  // Método para crear las cards de cada campo editable
  Widget _crearCard(String titulo, String campo, TextEditingController controlador, Function(String) onGuardar) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 6,
      child: ListTile(
        leading: Icon(Icons.edit, color: const Color(0xFF0288D1),),
        title: Text(titulo, style: TextStyle(fontFamily: 'Roboto', color: const Color(0xFF0288D1))),
        subtitle: Text(campo, style: TextStyle(fontFamily: 'Roboto', color: Colors.black.withOpacity(0.6))),
        trailing: IconButton(
          icon: Icon(Icons.edit, color: const Color(0xFF0288D1)),
          onPressed: () {
            _mostrarDialogoEdicion(titulo, campo, controlador, (nuevoValor) {
              onGuardar(nuevoValor);  // Aquí pasamos el valor editado
            });
          },
        ),
      ),
    );
  }

  void _mostrarDialogoEdicion(
      String titulo,
      String campo,
      TextEditingController controlador,
      Function(String) onGuardar,
      ) {
    controlador.text = campo;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Editar $titulo"),
          content: TextFormField(
            controller: controlador,
            decoration: InputDecoration(hintText: "Ingrese $titulo"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Este campo es obligatorio";
              }
              if (titulo == "Teléfono" &&
                  !RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$')
                      .hasMatch(value)) {
                return "Ingrese un teléfono válido";
              }
              if (titulo == "Fecha de nacimiento" &&
                  !RegExp(r'^\d{1,2}\/\d{1,2}\/\d{4}$').hasMatch(value)) {
                return "Ingrese una fecha válida (dd/mm/aaaa)";
              }
              return null;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text("Guardar"),
              onPressed: () {
                if (controlador.text.isNotEmpty) {
                  onGuardar(controlador.text); // Guardamos el texto editado
                  Navigator.pop(context);
                  _guardarDatosEnFirebase(); // Guardamos en Firebase
                }
              },
            ),
          ],
        );
      },
    );
  }




  // Mostrar opciones de imagen (Galería o cámara)
  void _mostrarOpcionesImagen() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Seleccionar imagen"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text("Seleccionar de la galería"),
                onTap: () {
                  Navigator.pop(context);
                  _seleccionarImagen();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text("Tomar foto"),
                onTap: () {
                  Navigator.pop(context);
                  _tomarFoto();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Método para seleccionar imagen de la galería (móvil y web)
  Future<void> _seleccionarImagen() async {
    if (kIsWeb) {
      try {
        final pickedBytes = await ImagePickerWeb.getImageAsBytes();
        if (pickedBytes != null) {
          setState(() {
            _imagenPerfilBytes = pickedBytes;
          });
          await _subirImagenYGuardarUrl();
        }
      } catch (e) {
        print("Error al seleccionar la imagen: $e");
      }
    } else {
      final ImagePicker _picker = ImagePicker();
      final XFile? imagen = await _picker.pickImage(source: ImageSource.gallery);
      if (imagen != null) {
        setState(() {
          _imagenPerfilBytes = File(imagen.path).readAsBytesSync();
        });
        await _subirImagenYGuardarUrl();
      }
    }
  }


  // Método para tomar foto con la cámara
  Future<void> _tomarFoto() async {
    if (kIsWeb) {
      try {
        final pickedBytes = await ImagePickerWeb.getImageAsBytes();
        if (pickedBytes != null) {
          setState(() {
            _imagenPerfilBytes = pickedBytes;
          });
          await _subirImagenYGuardarUrl();
        }
      } catch (e) {
        print("Error al tomar la foto: $e");
      }
    } else {
      final ImagePicker _picker = ImagePicker();
      final XFile? imagen = await _picker.pickImage(source: ImageSource.camera);
      if (imagen != null) {
        setState(() {
          _imagenPerfilBytes = File(imagen.path).readAsBytesSync();
        });
        await _subirImagenYGuardarUrl();
      }
    }
  }
}