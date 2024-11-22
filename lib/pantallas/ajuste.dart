import 'package:actividad3_app/personalizable/boton/boton_personalizado.dart';
import 'package:flutter/material.dart';

class Ajuste extends StatefulWidget {
  const Ajuste({Key? key}) : super(key: key);

  @override
  _AjusteState createState() => _AjusteState();
}

class _AjusteState extends State<Ajuste> {
  bool _modoOscuro = false;
  double _tamanoTexto = 16.0;
  String _esquemaColor = 'Azul';

  final Map<String, List<Color>> esquemasDeColor = {
    'Azul': [Color(0xFF0D47A1), Color(0xFF1F77D3), Color(0xFF4AA3F3)],
    'Verde': [Color(0xFF1B5E20), Color(0xFF4CAF50), Color(0xFF81C784)],
    'Rojo': [Color(0xFFB71C1C), Color(0xFFE53935), Color(0xFFFFCDD2)],
    'Amarillo': [Color(0xFFF57F17), Color(0xFFFFEB3B), Color(0xFFFFF176)],
  };

  void _cambiarTema(bool modoOscuro) {
    setState(() {
      _modoOscuro = modoOscuro;
    });
  }

  void _cambiarEsquemaColor(String color) {
    setState(() {
      _esquemaColor = color;
    });
  }

  void _restablecerAjustes() {
    setState(() {
      _modoOscuro = false;
      _tamanoTexto = 16.0;
      _esquemaColor = 'Azul';
    });
  }

  void _guardarAjustes() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ajustes guardados')),
    );
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
          bodyMedium: TextStyle(color: textoColor),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Ajustes"),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Personaliza tu experiencia',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: SwitchListTile(
                    title: Text(
                      'Modo oscuro',
                      style: TextStyle(color: textoColor),
                    ),
                    value: _modoOscuro,
                    onChanged: _cambiarTema,
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Tamaño del texto:',
                          style: TextStyle(fontSize: 18, color: textoColor),
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
                          },
                        ),
                        Text(
                          'Texto de muestra',
                          style: TextStyle(fontSize: _tamanoTexto, color: textoColor),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Esquema de color:',
                          style: TextStyle(fontSize: 18, color: textoColor),
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
                                style: TextStyle(fontSize: 16, color: textoColor),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
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
