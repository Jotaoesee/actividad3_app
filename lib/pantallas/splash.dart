import 'package:actividad3_app/pantallas/inicio_sesion.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _iconController;
  late Animation<double> _progressAnimation;
  late Animation<double> _iconAnimation;

  @override
  void initState() {
    super.initState();

    // Animación para la barra de progreso
    _progressController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_progressController)
      ..addListener(() {
        setState(() {});
      });

    // Animación para el icono de Flutter
    _iconController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _iconAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(CurvedAnimation(
      parent: _iconController,
      curve: Curves.easeInOut,
    ))..addListener(() {
      setState(() {});
    });

    _progressController.forward();
    _iconController.repeat(reverse: true);

    // Redirigir a la pantalla principal después de 5 segundos
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const InicioSesion()),
      );
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Icono animado
            ScaleTransition(
              scale: _iconAnimation,
              child: const Icon(
                Icons.flutter_dash,
                size: 100,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 30),
            // Barra de progreso
            Container(
              width: 200,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: LinearProgressIndicator(
                value: _progressAnimation.value,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
