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
    // Aquí puedes agregar la lógica para guardar los ajustes
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ajustes guardados')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajustes"),
        backgroundColor: const Color.fromARGB(255, 28, 108, 178),
      ),
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
              // Modo oscuro
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: SwitchListTile(
                  title: const Text('Modo oscuro', style: TextStyle(color: Colors.black)),
                  value: _modoOscuro,
                  onChanged: (bool value) {
                    _cambiarTema(value);
                  },
                ),
              ),
              const SizedBox(height: 20),
              // Tamaño de texto
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Tamaño del texto:',
                        style: TextStyle(fontSize: 18, color: Colors.black),
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
                        style: TextStyle(fontSize: _tamanoTexto),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Esquema de color
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Esquema de color:',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      DropdownButton<String>(
                        value: _esquemaColor,
                        onChanged: (String? nuevoEsquema) {
                          if (nuevoEsquema != null) {
                            _cambiarEsquemaColor(nuevoEsquema);
                          }
                        },
                        items: <String>['Azul', 'Verde', 'Rojo', 'Amarillo']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(fontSize: 16),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Fila con botones de restablecer y guardar
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Botón para restablecer ajustes con icono
                  BotonPersonalizado(
                    texto: "Restablecer ajustes",
                    icono: Icons.restore,
                    alPresionar: _restablecerAjustes,
                  ),
                  const SizedBox(width: 20), // Espacio entre botones
                  // Botón para guardar ajustes con icono
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
    );
  }
}
