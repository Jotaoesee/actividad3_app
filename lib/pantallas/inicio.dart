import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Inicio extends StatefulWidget {
  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  bool _vistaLista = true; // Controla si la vista es Lista o Grid

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inicio",
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0D47A1),
        actions: [
          IconButton(
            icon: Icon(_vistaLista ? FontAwesomeIcons.gripVertical : FontAwesomeIcons.listUl,
                color: Colors.white),
            onPressed: () {
              setState(() {
                _vistaLista = !_vistaLista; // Alternar entre Lista y Grid
              });
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0D47A1), // Azul oscuro
              Color(0xFF1F77D3), // Azul medio
              Color(0xFF4AA3F3), // Azul claro
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _contenido(),
      ),
    );
  }

  Widget _contenido() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('usuarios').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.white,));
        }

        if (snapshot.hasError) {
          return const Center(child: Text("Error al cargar los datos.",
            style: TextStyle(color: Colors.white),
          ));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No hay datos disponibles.",
            style: TextStyle(color: Colors.white),
          ));
        }

        final usuarios = snapshot.data!.docs;

        return _vistaLista
            ? _buildListView(usuarios)
            : _buildGridView(usuarios);
      },
    );
  }

  Widget _buildListView(List<QueryDocumentSnapshot> usuarios) {
    return ListView.separated(
      itemCount: usuarios.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final usuario = _mapearUsuario(usuarios[index]);
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: CircleAvatar(
            backgroundImage: usuario['fotoPerfil'] != null
                ? NetworkImage(usuario['fotoPerfil'])
                : null,
            child: usuario['fotoPerfil'] == null
                ? const Icon(Icons.person, color: Colors.white,)
                : null,
            backgroundColor: Colors.grey,
          ),
          title: Text('${usuario['nombre']} ${usuario['apellido']}',
              style: const TextStyle(color: Colors.white, fontFamily: 'Roboto', fontSize: 16)),
          subtitle: Text(
            'Fecha de nacimiento: ${usuario['fechaNacimiento']}\nTeléfono: ${usuario['telefono']}\nCiudad: ${usuario['ciudad']}',
            style: const TextStyle(color: Colors.white, fontFamily: 'Roboto', fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
    );
  }

  Widget _buildGridView(List<QueryDocumentSnapshot> usuarios) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Número de celdas por fila
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        childAspectRatio: 3 / 2, // Relación de aspecto de las celdas
      ),
      itemCount: usuarios.length,
      itemBuilder: (context, index) {
        final usuario = _mapearUsuario(usuarios[index]);
        return Card(
          elevation: 6,
          color: Colors.white.withOpacity(0.8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: usuario['fotoPerfil'] != null
                          ? NetworkImage(usuario['fotoPerfil'])
                          : null,
                      child: usuario['fotoPerfil'] == null
                          ? const Icon(Icons.person, color: Colors.white,)
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${usuario['nombre']} ${usuario['apellido']}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            fontFamily: 'Roboto',
                            color: Color(0xFF0288D1)
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Fecha: ${usuario['fechaNacimiento']}',
                  style: const TextStyle(fontSize: 12, fontFamily: 'Roboto', color: Color(0xFF0288D1)),
                ),
                const SizedBox(height: 4),
                Text(
                  'Teléfono: ${usuario['telefono']}',
                  style: const TextStyle(fontSize: 12, fontFamily: 'Roboto', color: Color(0xFF0288D1)),
                ),
                const SizedBox(height: 4),
                Text(
                  'Ciudad: ${usuario['ciudad']}',
                  style: const TextStyle(fontSize: 12, fontFamily: 'Roboto', color: Color(0xFF0288D1)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Método para mapear un usuario con valores seguros
  Map<String, dynamic> _mapearUsuario(QueryDocumentSnapshot usuario) {
    final data = usuario.data() as Map<String, dynamic>;
    return {
      'nombre': data['nombre'] ?? 'Sin nombre',
      'apellido': data['apellido'] ?? 'Sin apellido',
      'fechaNacimiento': data['fecha_nacimiento'] ?? 'Sin fecha',
      'telefono': data['telefono'] ?? 'Sin teléfono',
      'ciudad': data['ciudad'] ?? 'Sin ciudad',
      'fotoPerfil': data['fotoPerfil'],
    };
  }
}