import 'package:actividad3_app/pantallas/inicio_sesion.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _iconController;
  late Animation<double> _progressAnimation;


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
        if (mounted) {
          setState(() {});
        }
      });

    // Animación para el icono
    _iconController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _progressController.forward();
    _iconController.repeat(reverse: true);

    // Redirigir a la pantalla principal después de 5 segundos
    Future.delayed(const Duration(seconds: 5), () {
      if(mounted){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const InicioSesion()),
        );
      }
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Icono animado
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 9000),
                child: FadeInDown(
                  key: UniqueKey(),
                  child:  const Icon(
                    Icons.flutter_dash,
                    size: 100,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Barra de progreso
              Container(
                width: 200,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: _progressAnimation.value,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.greenAccent), // Barra de progreso verde
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}