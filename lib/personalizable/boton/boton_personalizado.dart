import 'package:flutter/material.dart';

class BotonPersonalizado extends StatefulWidget {
  final String texto;
  final IconData icono;
  final VoidCallback alPresionar;

  const BotonPersonalizado({
    Key? key,
    required this.texto,
    required this.icono,
    required this.alPresionar,
  }) : super(key: key);

  @override
  _BotonPersonalizadoState createState() => _BotonPersonalizadoState();
}

class _BotonPersonalizadoState extends State<BotonPersonalizado> {
  bool esPresionado = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          esPresionado = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          esPresionado = false;
        });
      },
      onTapCancel: () {
        setState(() {
          esPresionado = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: EdgeInsets.symmetric(
          horizontal: esPresionado ? 25 : 20,
          vertical: esPresionado ? 12 : 15,
        ),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 28, 108, 178),
          borderRadius: BorderRadius.circular(20),
          boxShadow: esPresionado
              ? []
              : [
            const BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: widget.alPresionar,
          icon: Icon(widget.icono, color: Colors.white),
          label: Text(
            widget.texto,
            style: const TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.zero,
            shadowColor: Colors.transparent,
          ),
        ),
      ),
    );
  }
}
