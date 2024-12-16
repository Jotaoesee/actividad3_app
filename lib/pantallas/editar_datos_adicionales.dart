import 'package:flutter/material.dart';
import '../clases/data_holder.dart';

class EditarDatosAdicionales extends StatefulWidget {
  final String userId;
  const EditarDatosAdicionales({Key? key, required this.userId}) : super(key: key);

  @override
  _EditarDatosAdicionalesState createState() => _EditarDatosAdicionalesState();
}

class _EditarDatosAdicionalesState extends State<EditarDatosAdicionales> {
  final DataHolder _dataHolder = DataHolder();
  final _formKey = GlobalKey<FormState>();
  final _descripcionController = TextEditingController();
  final _ocupacionController = TextEditingController();
  List<String> _intereses = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _descripcionController.dispose();
    _ocupacionController.dispose();
    super.dispose();
  }

  Future<void> _guardarDatosAdicionales() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Recoge los datos del formulario
      final datos = {
        'descripcion': _descripcionController.text,
        'intereses': _intereses,
        'ocupacion': _ocupacionController.text,
      };

      try {
        // Llama a la función para guardar los datos en Firestore
        await _dataHolder.firebaseAdmin.guardarDatosAdicionales(widget.userId, datos);
        _mostrarMensaje("Datos guardados correctamente", isSuccess: true);
      } catch (e) {
        _mostrarMensaje("Error al guardar los datos: $e");
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _mostrarMensaje(String mensaje, {bool isSuccess = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
      ),
    );
  }


  void _toggleInteres(String interes, bool? value) {
    setState(() {
      if (value == true) {
        _intereses.add(interes);
      } else {
        _intereses.remove(interes);
      }
    });
  }

  Widget _campoDeTexto({
    required TextEditingController controlador,
    required String labelText,
    required IconData icono,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controlador,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: labelText,
        prefixIcon: Icon(icono, color: Colors.grey),
        border: const OutlineInputBorder(),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF0288D1)),
        ),
      ),
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Datos Adicionales",  style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0D47A1),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _campoDeTexto(
                      controlador: _descripcionController,
                      labelText: "Descripción",
                      icono: Icons.description,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Ingrese una descripción";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Selecciona tus intereses",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Wrap(
                      spacing: 8.0,
                      children: [
                        ...["futbol", "cine", "viajar", "videojuegos", "libros"].map((interes) {
                          return FilterChip(
                            label: Text(interes),
                            selected: _intereses.contains(interes),
                            onSelected: (value) => _toggleInteres(interes, value),
                            selectedColor: const Color(0xFF0288D1).withOpacity(0.4),
                            checkmarkColor: Colors.black,
                            showCheckmark: true,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          );
                        })
                      ],
                    ),
                    const SizedBox(height: 20),
                    _campoDeTexto(
                      controlador: _ocupacionController,
                      labelText: "Ocupación",
                      icono: Icons.work,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Ingrese su ocupación";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _guardarDatosAdicionales,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0288D1),
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text(
                        "Guardar",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            const Positioned.fill(
              child: Center(
                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white)),
              ),
            ),
        ],
      ),
    );
  }
}