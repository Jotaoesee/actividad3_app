import 'package:actividad3_app/personalizable/boton/boton_personalizado.dart';
import 'package:flutter/material.dart';
import '../clases/data_holder.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Ajuste extends StatefulWidget {
  const Ajuste({Key? key}) : super(key: key);

  @override
  _AjusteState createState() => _AjusteState();
}

class _AjusteState extends State<Ajuste> {
  bool _modoOscuro = false;
  double _tamanoTexto = 16.0;
  String _esquemaColor = 'Azul';

  final DataHolder _dataHolder = DataHolder();
  final Map<String, List<Color>> esquemasDeColor = {
    'Azul': [Color(0xFF0D47A1), Color(0xFF1F77D3), Color(0xFF4AA3F3)],
    'Verde': [Color(0xFF1B5E20), Color(0xFF4CAF50), Color(0xFF81C784)],
    'Rojo': [Color(0xFFB71C1C), Color(0xFFE53935), Color(0xFFFFCDD2)],
    'Amarillo': [Color(0xFFF57F17), Color(0xFFFFEB3B), Color(0xFFFFF176)],
  };


  @override
  void initState() {
    super.initState();
    _cargarAjustes();
  }

  Future<void> _cargarAjustes() async {
    try {
      User? usuario = FirebaseAuth.instance.currentUser;
      if(usuario != null){
        Map<String, dynamic> ajustes = await _dataHolder.firebaseAdmin.obtenerAjustes(usuario.uid);
        setState(() {
          _modoOscuro = ajustes['modoOscuro'] ?? false;
          _tamanoTexto = ajustes['tamanoTexto'] ?? 16.0;
          _esquemaColor = ajustes['esquemaColor'] ?? 'Azul';
        });
      }
    } catch (e) {
      print('Error al cargar los ajustes: $e');
    }
  }


  void _cambiarTema(bool modoOscuro) {
    setState(() {
      _modoOscuro = modoOscuro;
    });
    _guardarAjustes();
  }

  void _cambiarEsquemaColor(String color) {
    setState(() {
      _esquemaColor = color;
    });
    _guardarAjustes();
  }


  void _restablecerAjustes() {
    setState(() {
      _modoOscuro = false;
      _tamanoTexto = 16.0;
      _esquemaColor = 'Azul';
    });
    _guardarAjustes();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ajustes restablecidos')),
    );
  }

  void _guardarAjustes() async {
    try {
      User? usuario = FirebaseAuth.instance.currentUser;
      if(usuario != null){
        final ajustesData = {
          'modoOscuro': _modoOscuro,
          'tamanoTexto': _tamanoTexto,
          'esquemaColor': _esquemaColor,
        };
        await _dataHolder.firebaseAdmin.guardarAjustes(usuario.uid, ajustesData);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ajustes guardados')),
        );
      }
    } catch (e) {
      print('Error al guardar ajustes en Firebase: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar ajustes: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final Color fondoColor = _modoOscuro ? Colors.black : esquemasDeColor[_esquemaColor]![0];
    final Color textoColor = _modoOscuro ? Colors.white : Colors.black;

    return Theme(
      data: ThemeData(
        brightness: _modoOscuro ? Brightness.dark : Brightness.light,
        primaryColor: fondoColor,
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: textoColor, fontFamily: 'Roboto'),
          titleMedium: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
            title: const Text("Ajustes", style: TextStyle(color: Colors.white),),
            backgroundColor: fondoColor),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Personaliza tu experiencia',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Roboto'
                  ),
                ),
                const SizedBox(height: 20),
                // Modo oscuro
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SwitchListTile(
                    title: Text(
                      'Modo oscuro',
                      style: TextStyle(color: textoColor, fontFamily: 'Roboto'),
                    ),
                    value: _modoOscuro,
                    onChanged: _cambiarTema,
                    activeColor: const Color(0xFF0288D1),
                    trackColor: MaterialStateProperty.resolveWith<Color>((states) {
                      if (states.contains(MaterialState.selected)) {
                        return const Color(0xFF0288D1).withOpacity(0.7);
                      }
                      return  Colors.grey.withOpacity(0.5);
                    }),
                  ),
                ),
                const SizedBox(height: 20),
                // Tamaño del texto
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    child: Column(
                      children: [
                        Text(
                          'Tamaño del texto:',
                          style: TextStyle(fontSize: 18, color: textoColor, fontFamily: 'Roboto'),
                        ),
                        Slider(
                          value: _tamanoTexto,
                          min: 10.0,
                          max: 30.0,
                          divisions: 20,
                          label: _tamanoTexto.round().toString(),
                          onChanged: (double nuevoValor) {
                            setState(() {
                              _tamanoTexto = nuevoValor;
                            });
                            _guardarAjustes();
                          },
                          activeColor: const Color(0xFF0288D1),
                          thumbColor: const Color(0xFF0288D1),
                        ),
                        Text(
                          'Texto de muestra',
                          style: TextStyle(fontSize: _tamanoTexto, color: textoColor, fontFamily: 'Roboto'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Esquema de color
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    child: Column(
                      children: [
                        Text(
                          'Esquema de color:',
                          style: TextStyle(fontSize: 18, color: textoColor, fontFamily: 'Roboto'),
                        ),
                        DropdownButton<String>(
                          value: _esquemaColor,
                          onChanged: (String? nuevoEsquema) {
                            if (nuevoEsquema != null) {
                              _cambiarEsquemaColor(nuevoEsquema);
                            }
                          },
                          items: esquemasDeColor.keys
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(fontSize: 16, color: textoColor, fontFamily: 'Roboto'),
                              ),
                            );
                          }).toList(),
                          dropdownColor: Colors.white,
                          style:  TextStyle(fontSize: 16, color: textoColor, fontFamily: 'Roboto'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Botones de acción
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BotonPersonalizado(
                      texto: "Restablecer ajustes",
                      icono: Icons.restore,
                      alPresionar: _restablecerAjustes,
                    ),
                    const SizedBox(width: 20),
                    BotonPersonalizado(
                      texto: "Guardar ajustes",
                      icono: Icons.save,
                      alPresionar: _guardarAjustes,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}