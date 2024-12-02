import 'package:actividad3_app/pantallas/inicio.dart';
import 'package:actividad3_app/pantallas/perfil_usuario.dart';
import 'package:actividad3_app/pantallas/splash.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    Inicio(),
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
          StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Estado de carga: muestra un indicador de progreso
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                // Estado de error: muestra un mensaje de error
                return ListTile(
                  leading: const Icon(Icons.error, color: Colors.red),
                  title: const Text('Error al cargar usuario'),
                  subtitle: const Text('Por favor, intenta nuevamente.'),
                );
              } else if (!snapshot.hasData || snapshot.data == null) {
                // Caso en que no hay datos del usuario (usuario no autenticado)
                return ListTile(
                  leading: const Icon(Icons.person_off, color: Colors.grey),
                  title: const Text('Usuario no autenticado'),
                  subtitle: const Text('Inicia sesión para continuar.'),
                  onTap: () {
                    // Acción para redirigir a pantalla de inicio de sesión
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Splash()),
                    );
                  },
                );
              }

              // Usuario autenticado: muestra los datos
              final usuario = snapshot.data!;
              final nombreUsuario = usuario.displayName ?? 'Nombre de Usuario';
              final correoUsuario = usuario.email ?? 'usuario@ejemplo.com';

              return UserAccountsDrawerHeader(
                accountName: Text(nombreUsuario),
                accountEmail: Text(correoUsuario),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: Colors.blue),
                ),
                onDetailsPressed: null, // Acción si se desea implementar
              );
            },
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
              setState(() {
                _indiceSeleccionado = 1; // Cambia a la pantalla de perfil en la barra de navegación
              });

            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar sesión'),
            onTap: () {
              // Lógica para cerrar sesión
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Splash()), // Ajusta la navegación según tu app
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
