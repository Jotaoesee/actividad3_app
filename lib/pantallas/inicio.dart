import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
        title: const Text("Inicio"),
        actions: [
          IconButton(
            icon: Icon(_vistaLista ? Icons.grid_view : Icons.list),
            onPressed: () {
              setState(() {
                _vistaLista = !_vistaLista; // Alternar entre Lista y Grid
              });
            },
          ),
        ],
      ),
      body: _contenido(),
    );
  }

  Widget _contenido() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('usuarios').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text("Error al cargar los datos."));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No hay datos disponibles."));
        }

        final usuarios = snapshot.data!.docs;

        return _vistaLista
            ? _buildListView(usuarios)
            : _buildGridView(usuarios);
      },
    );
  }

  Widget _buildListView(List<QueryDocumentSnapshot> usuarios) {
    return ListView.builder(
      itemCount: usuarios.length,
      itemBuilder: (context, index) {
        final usuario = _mapearUsuario(usuarios[index]);
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: usuario['fotoPerfil'] != null
                ? NetworkImage(usuario['fotoPerfil'])
                : null,
            child: usuario['fotoPerfil'] == null
                ? const Icon(Icons.person)
                : null,
          ),
          title: Text('${usuario['nombre']} ${usuario['apellido']}'),
          subtitle: Text(
              'Fecha de nacimiento: ${usuario['fechaNacimiento']}\nTeléfono: ${usuario['telefono']}\nCiudad: ${usuario['ciudad']}'),
        );
      },
    );
  }

  Widget _buildGridView(List<QueryDocumentSnapshot> usuarios) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Número de celdas por fila
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 3 / 2, // Relación de aspecto de las celdas
      ),
      itemCount: usuarios.length,
      itemBuilder: (context, index) {
        final usuario = _mapearUsuario(usuarios[index]);
        return Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: usuario['fotoPerfil'] != null
                          ? NetworkImage(usuario['fotoPerfil'])
                          : null,
                      child: usuario['fotoPerfil'] == null
                          ? const Icon(Icons.person)
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${usuario['nombre']} ${usuario['apellido']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Fecha: ${usuario['fechaNacimiento']}',
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  'Teléfono: ${usuario['telefono']}',
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  'Ciudad: ${usuario['ciudad']}',
                  style: const TextStyle(fontSize: 12),
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
