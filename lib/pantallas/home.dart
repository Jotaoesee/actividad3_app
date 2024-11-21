import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _pantallaActual = "Inicio";  // Variable para controlar la pantalla actual
  int _indiceSeleccionado = 0;  // Índice para controlar la pestaña seleccionada

  // Lista de widgets que representarán las diferentes pantallas
  final List<Widget> _pantallas = [
    const Center(child: Text('Pantalla Inicio')),
    const Center(child: Text('Pantalla Perfil')),
    const Center(child: Text('Pantalla Configuración')),
  ];

  @override
  Widget build(BuildContext contexto) {
    return Scaffold(
      appBar: _crearAppBar(),
      drawer: _crearDrawer(),
      body: _pantallas[_indiceSeleccionado],  // Cambia el cuerpo según la pestaña seleccionada
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
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            onTap: () {
              Navigator.pop(context);
              setState(() {
                _indiceSeleccionado = 0;  // Cambiar a la pantalla de inicio
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configuración'),
            onTap: () {
              Navigator.pop(context);
              setState(() {
                _indiceSeleccionado = 2;  // Cambiar a la pantalla de configuración
              });
            },
          ),
        ],
      ),
    );
  }

  // AppBar con el título que cambia según la pestaña seleccionada
  AppBar _crearAppBar() {
    return AppBar(
      title: Text("Pantalla de $_pantallaActual"),  // Actualizar el título de acuerdo a la pantalla seleccionada
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
          _indiceSeleccionado = indice;  // Cambiar el índice de la pestaña seleccionada
          _pantallaActual = _indiceSeleccionado == 0
              ? "Inicio"
              : _indiceSeleccionado == 1
              ? "Perfil"
              : "Configuración";  // Cambiar el nombre de la pantalla en la AppBar
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
          label: 'Configuración',
        ),
      ],
    );
  }
}
