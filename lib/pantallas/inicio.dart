import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../clases/data_holder.dart';
import '../clases/firebase_admin.dart';

class Inicio extends StatefulWidget {
  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  bool _vistaLista = true;
  final DataHolder _dataHolder = DataHolder();
  final TextEditingController _buscarController = TextEditingController();
  bool _buscando = false;


  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>>(
      stream: _dataHolder.getStreamDeAjustes(),
      builder: (context, snapshot) {
        if(!snapshot.hasData){
          return const Center(child: CircularProgressIndicator(color: Colors.white,));
        }
        final ajustes = snapshot.data!;
        final modoOscuro = ajustes['modoOscuro'] ?? false;
        final esquemaColor = ajustes['esquemaColor'] ?? 'Azul';

        final Map<String, List<Color>> esquemasDeColor = {
          'Azul': [Color(0xFF0D47A1), Color(0xFF1F77D3), Color(0xFF4AA3F3)],
          'Verde': [Color(0xFF1B5E20), Color(0xFF4CAF50), Color(0xFF81C784)],
          'Rojo': [Color(0xFFB71C1C), Color(0xFFE53935), Color(0xFFFFCDD2)],
          'Amarillo': [Color(0xFFF57F17), Color(0xFFFFEB3B), Color(0xFFFFF176)],
        };
        final Color fondoColor = modoOscuro ? Colors.black : esquemasDeColor[esquemaColor]![0];
        final Color textoColor = modoOscuro ? Colors.white : Colors.black;
        final double tamanoTexto = ajustes['tamanoTexto'] ?? 16.0;


        return Theme(
          data: ThemeData(
            brightness: modoOscuro ? Brightness.dark : Brightness.light,
            primaryColor: fondoColor,
            textTheme: TextTheme(
              bodyMedium: TextStyle(color: textoColor, fontFamily: 'Roboto', fontSize: tamanoTexto),
            ),
          ),
          child: Scaffold(
            appBar: AppBar(
              title: const Text("Inicio",
                  style: TextStyle(color: Colors.white)),
              backgroundColor: fondoColor,
              actions: [
                IconButton(
                  icon: Icon(_vistaLista ? FontAwesomeIcons.gripVertical : FontAwesomeIcons.listUl,
                      color: Colors.white),
                  onPressed: () {
                    setState(() {
                      _vistaLista = !_vistaLista;
                    });
                  },
                ),
              ],
            ),
            body: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: esquemasDeColor[esquemaColor]!,
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _buscarController,
                                decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: 'Buscar por nombre',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.search, color: Colors.white,),
                              onPressed: (){
                                setState(() {

                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: _contenido(tamanoTexto, textoColor),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_buscando)
                  const Positioned.fill(
                    child: Center(
                        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white))
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }


  Widget _contenido(double tamanoTexto, Color textColor) {
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

        List<QueryDocumentSnapshot> usuarios = snapshot.data!.docs;
        if(_buscarController.text.isNotEmpty){
          usuarios =  usuarios.where((usuario) => _mapearUsuario(usuario)['nombre'].toLowerCase().contains(_buscarController.text.toLowerCase())).toList();
        }


        return _vistaLista
            ? _buildListView(usuarios, tamanoTexto, textColor)
            : _buildGridView(usuarios, tamanoTexto, textColor);

      },
    );
  }




  Widget _buildListView(List<QueryDocumentSnapshot> usuarios, double tamanoTexto, Color textColor) {
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
              style:  TextStyle(color: textColor, fontFamily: 'Roboto', fontSize: tamanoTexto)),
          subtitle: Text(
            'Fecha de nacimiento: ${usuario['fechaNacimiento']}\nTeléfono: ${usuario['telefono']}\nCiudad: ${usuario['ciudad']}',
            style:  TextStyle(color: textColor, fontFamily: 'Roboto', fontSize: tamanoTexto - 2),
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
    );
  }


  Widget _buildGridView(List<QueryDocumentSnapshot> usuarios, double tamanoTexto, Color textColor) {
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
                        style:  TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: tamanoTexto - 2,
                            fontFamily: 'Roboto',
                            color: const Color(0xFF0288D1)
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Fecha: ${usuario['fechaNacimiento']}',
                  style:  TextStyle(fontSize: tamanoTexto - 4, fontFamily: 'Roboto', color: const Color(0xFF0288D1)),
                ),
                const SizedBox(height: 4),
                Text(
                  'Teléfono: ${usuario['telefono']}',
                  style:  TextStyle(fontSize: tamanoTexto - 4, fontFamily: 'Roboto', color: const Color(0xFF0288D1)),
                ),
                const SizedBox(height: 4),
                Text(
                  'Ciudad: ${usuario['ciudad']}',
                  style:  TextStyle(fontSize: tamanoTexto - 4, fontFamily: 'Roboto', color: const Color(0xFF0288D1)),
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