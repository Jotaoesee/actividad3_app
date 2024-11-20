import 'package:actividad3_app/pantallas/inicio.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    // Inicializamos el AnimationController con la duración de la animación
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this, // Necesario para que la animación se sincronice con el ciclo de vida del widget
    )..forward();  // Ejecutamos la animación inmediatamente

    // Definimos la animación de desplazamiento (SlideTransition)
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),  // Comienza fuera de la pantalla, en la parte inferior
      end: Offset.zero,  // Termina en la posición original
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,  // Tipo de curva para suavizar la animación
    ));

    // Redirige automáticamente a la siguiente pantalla después de 3 segundos
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        _crearRutaConAnimacion(),
      );
    });
  }

  // Función que crea la transición personalizada de la pantalla de inicio
  PageRouteBuilder _crearRutaConAnimacion() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const Inicio(),  // Página de destino
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Animación de desvanecimiento
        var tween = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeIn));
        var opacityAnimation = animation.drive(tween);

        return FadeTransition(
          opacity: opacityAnimation,  // Aplicamos la animación de opacidad
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Center(
          child: SlideTransition(
            position: _offsetAnimation,  // Animación de deslizamiento
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.app_registration, // Logo de ejemplo
                  size: 80,
                  color: Colors.white,
                ),
                SizedBox(height: 20),
                Text(
                  "Mi Aplicación",  // Nombre de la aplicación
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
