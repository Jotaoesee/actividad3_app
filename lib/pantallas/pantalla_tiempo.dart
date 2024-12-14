import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

enum EstadoTiempo { inicial, cargando, cargado, error }

class PantallaTiempo extends StatefulWidget {
  const PantallaTiempo({Key? key}) : super(key: key);
  @override
  _PantallaTiempoState createState() => _PantallaTiempoState();
}

class _PantallaTiempoState extends State<PantallaTiempo> {
  final ServicioTiempo _servicioTiempo = ServicioTiempo();
  List<HoraTiempo> _datosTiempo = [];
  EstadoTiempo _estadoTiempo = EstadoTiempo.inicial;
  String? _mensajeError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarDatosTiempo();
      initializeDateFormatting('es_ES', null);
    });
  }

  Future<void> _cargarDatosTiempo() async {
    setState(() {
      _estadoTiempo = EstadoTiempo.cargando;
    });
    try {
      final Position posicion = await _servicioTiempo.obtenerPosicionActual();
      final datosTiempo = await _servicioTiempo.obtenerDatosTiempo(posicion);
      setState(() {
        _datosTiempo = datosTiempo;
        _estadoTiempo = EstadoTiempo.cargado;
      });
    } catch (error) {
      setState(() {
        _estadoTiempo = EstadoTiempo.error;
        _mensajeError = error.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Pronóstico del Tiempo', style: TextStyle(color: Colors.white)),
          backgroundColor: const Color(0xFF0D47A1)), // Azul más oscuro
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0D47A1), // Azul oscuro
              Color(0xFF1F77D3), // Azul medio
              Color(0xFF4AA3F3), // Azul claro
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _construirCuerpo(),
      ),
    );
  }

  Widget _construirCuerpo() {
    switch (_estadoTiempo) {
      case EstadoTiempo.inicial:
        return const Center(child: Text('Presiona el botón para cargar el tiempo', style: TextStyle(color: Colors.white)));
      case EstadoTiempo.cargando:
        return const Center(child: CircularProgressIndicator(color: Colors.white,));
      case EstadoTiempo.cargado:
        return RefreshIndicator(
          onRefresh: () async {
            _cargarDatosTiempo();
          },
          child: ListView.builder(
            itemCount: _datosTiempo.length,
            itemBuilder: (context, index) {
              final horaTiempo = _datosTiempo[index];
              final ahora = DateTime.now().add(Duration(hours: index));
              final horaFormateada = DateFormat('HH:mm').format(ahora);
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.white.withOpacity(0.8),
                child: ListTile(
                  title: Text('Hora: $horaFormateada', style: TextStyle(color: Color(0xFF0288D1))),
                  subtitle: Text(
                    'Temp: ${horaTiempo.temperatura.toStringAsFixed(1)}°C, '
                        'Humedad: ${horaTiempo.humedadRelativa}%, '
                        'Punto de Rocío: ${horaTiempo.puntoRocio.toStringAsFixed(1)}°C',
                    style: const TextStyle(color: Color(0xFF0288D1)),
                  ),
                ),
              );
            },
          ),
        );
      case EstadoTiempo.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Error: ${_mensajeError ?? "No se pudo cargar el clima"}', style: const TextStyle(color: Colors.white)),
          ),
        );
      default:
        return const Center(child: Text('Estado Desconocido', style: TextStyle(color: Colors.white)));
    }
  }
}

class HoraTiempo {
  final double temperatura;
  final int humedadRelativa;
  final double puntoRocio;

  HoraTiempo({required this.temperatura, required this.humedadRelativa, required this.puntoRocio});

  factory HoraTiempo.fromJson(Map<String, dynamic> json) {
    return HoraTiempo(
      temperatura: json['temperature_2m'] as double,
      humedadRelativa: json['relative_humidity_2m'] as int,
      puntoRocio: json['dew_point_2m'] as double,
    );
  }
}

class ServicioTiempo {
  static const String _urlApiTiempo = 'https://api.open-meteo.com/v1/forecast';

  Future<Position> obtenerPosicionActual() async {
    bool servicioHabilitado;
    LocationPermission permiso;

    servicioHabilitado = await Geolocator.isLocationServiceEnabled();
    if (!servicioHabilitado) {
      return Future.error('Los servicios de ubicación están desactivados.');
    }

    permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
      if (permiso == LocationPermission.denied) {
        return Future.error('Los permisos de ubicación están denegados');
      }
    }

    if (permiso == LocationPermission.deniedForever) {
      return Future.error(
          'Los permisos de ubicación están permanentemente denegados, no podemos solicitar permisos.');
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<List<HoraTiempo>> obtenerDatosTiempo(Position posicion) async {
    final url = Uri.parse(
        '$_urlApiTiempo?latitude=${posicion.latitude}&longitude=${posicion.longitude}&hourly=temperature_2m,relative_humidity_2m,dew_point_2m&forecast_days=1');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final hourly = data['hourly'];

        List<HoraTiempo> horasTiempo = [];
        for (int i = 0; i < hourly['temperature_2m'].length; i++) {
          final Map<String, dynamic> horaData = {
            'temperature_2m': hourly['temperature_2m'][i],
            'relative_humidity_2m': hourly['relative_humidity_2m'][i],
            'dew_point_2m': hourly['dew_point_2m'][i],
          };
          horasTiempo.add(HoraTiempo.fromJson(horaData));
        }
        return horasTiempo;
      } else {
        throw Exception(
            'Error al obtener datos del tiempo. Código de estado: ${response.statusCode}');
      }
    } catch (error) {
      print('Error al obtener datos del tiempo: $error');
      throw Exception('Error al obtener datos del tiempo: $error');
    }
  }
}