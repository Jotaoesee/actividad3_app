import 'package:actividad3_app/pantallas/splash.dart';
import 'package:actividad3_app/personalizable/boton/boton_personalizado.dart';
import 'package:flutter/material.dart';

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
  String _edad = "30";
  String _fechaNacimiento = "01/01/1990";

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _ciudadController = TextEditingController();
  final TextEditingController _edadController = TextEditingController();
  final TextEditingController _fechaNacimientoController = TextEditingController();

  // Esquema de colores similar al de la clase Ajuste
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
        body: Container(
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
                const CircleAvatar(
                  radius: 70,
                  backgroundImage: NetworkImage(
                    'https://via.placeholder.com/150', // URL de imagen de perfil
                  ),
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
                  "usuario@correo.com", // El correo es estático por ahora
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

                const SizedBox(height: 40),
                // Botón de cerrar sesión
                BotonPersonalizado(
                  texto: "Cerrar sesión",
                  icono: Icons.logout,
                  alPresionar: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) =>  Splash())
                    );
                  },
                ),
              ],
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
  void _mostrarDialogoEdicion(String titulo, String campo, TextEditingController controlador, VoidCallback onGuardar) {
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
}
