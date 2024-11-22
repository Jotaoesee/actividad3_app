import 'package:actividad3_app/pantallas/perfil_usuario.dart';
import 'package:actividad3_app/pantallas/splash.dart';
import 'package:flutter/material.dart';
import 'ajuste.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _indiceSeleccionado = 0; // Índice para controlar la pestaña seleccionada

  // Lista de widgets que representarán las diferentes pantallas
  final List<Widget> _pantallas = [
    const Center(child: Text('Pantalla de Inicio', style: TextStyle(fontSize: 24))),
    const PerfilUsuario(),
    const Ajuste(),
  ];

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
          const UserAccountsDrawerHeader(
            accountName: Text('Usuario'),
            accountEmail: Text('usuario@ejemplo.com'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.blue),
            ),
            onDetailsPressed: null, // Acción cuando se haga clic en el avatar (sin implementación ahora)
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
          // Nueva opción para ir al perfil
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Perfil'),
            onTap: () {
              Navigator.pop(context); // Cierra el Drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PerfilUsuario()), // Navegar a la pantalla de perfil
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar sesión'),
            onTap: () {
              // Aquí puedes añadir tu lógica de cierre de sesión
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Splash()), // Ajusta la navegación de tu app
              );
              print("Cerrar sesión"); // Aquí podrías llamar a FirebaseAuth o el sistema de autenticación que estés utilizando
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
