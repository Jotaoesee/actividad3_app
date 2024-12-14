import 'package:actividad3_app/pantallas/inicio.dart';
import 'package:actividad3_app/pantallas/pantalla_tiempo.dart';
import 'package:actividad3_app/pantallas/perfil_usuario.dart';
import 'package:actividad3_app/pantallas/splash.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../clases/firebase_admin.dart';
import 'ajuste.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _indiceSeleccionado = 0; // Índice para controlar la pestaña seleccionada
  User? _usuario; // Variable para almacenar el usuario actual
  String? _nombreUsuario; // Variable para almacenar el nombre del usuario

  // Lista de widgets que representarán las diferentes pantallas
  final List<Widget> _pantallas = [
    Inicio(),
    const PerfilUsuario(),
    const Ajuste(),
  ];

  @override
  void initState() {
    super.initState();
    _cargarUsuario();
  }

  void _cargarUsuario() async {
    // Cargar los datos del usuario desde FirebaseAuth
    FirebaseAuth.instance.authStateChanges().listen((usuario) async {
      if (usuario != null) {
        // Obtén los datos adicionales del usuario desde Firestore
        FirebaseAdmin firebaseAdmin = FirebaseAdmin();
        String? nombre = await firebaseAdmin.obtenerNombreUsuario();
        setState(() {
          _usuario = usuario;
          _nombreUsuario = nombre; // Asigna el nombre obtenido
        });
      } else {
        setState(() {
          _usuario = null;
          _nombreUsuario = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _crearAppBar(),
      drawer: _crearDrawer(),
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
        child: _pantallas[_indiceSeleccionado], // Cambia el cuerpo según la pestaña seleccionada
      ),
      bottomNavigationBar: _crearBarraNavegacionInferior(),
    );
  }

  // Función para el menú del Drawer
  Widget _crearDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          if (_usuario == null)
            ListTile(
              leading: const Icon(Icons.person_off, color: Colors.grey),
              title: const Text('Usuario no autenticado'),
              subtitle: const Text('Inicia sesión para continuar.'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Splash()),
                );
              },
            )
          else
            UserAccountsDrawerHeader(
              accountName: Text(_nombreUsuario ?? 'Usuario no registrado'),
              accountEmail: Text(_usuario!.email ?? 'Correo no disponible'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Colors.blue),
              ),
            ),

          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            onTap: () {
              Navigator.pop(context); // Cierra el Drawer
              setState(() {
                _indiceSeleccionado = 0; // Cambiar a la pantalla de inicio
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Ajustes'),
            onTap: () {
              Navigator.pop(context); // Cierra el Drawer
              setState(() {
                _indiceSeleccionado = 2; // Cambiar a la pantalla de ajustes
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Perfil'),
            onTap: () {
              Navigator.pop(context); // Cierra el Drawer
              setState(() {
                _indiceSeleccionado = 1; // Cambia a la pantalla de perfil en la barra de navegación
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Coste Electricidad'),
            onTap: () {
              Navigator.pop(context); // Cierra el Drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PantallaTiempo()), // Navegar directamente a CosteElectricidad
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar sesión'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Splash()),
              );
              print("Cerrar sesión");
            },
          ),
        ],
      ),
    );
  }

  // AppBar con el título que cambia según la pestaña seleccionada
  AppBar _crearAppBar() {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 28, 108, 178),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            print("Buscar...");
          },
        ),
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {
            print("Notificaciones...");
          },
        ),
      ],
    );
  }

  // BottomNavigationBar con tres pestañas: Inicio, Perfil y Configuración
  Widget _crearBarraNavegacionInferior() {
    return BottomNavigationBar(
      currentIndex: _indiceSeleccionado,
      onTap: (int indice) {
        setState(() {
          _indiceSeleccionado = indice;
        });
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Perfil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Ajustes',
        ),
      ],
    );
  }
}

