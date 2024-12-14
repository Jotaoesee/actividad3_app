import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpAdmin {
  final String apiUrl = 'https://apidatos.ree.es/es/datos/balance/balance-electrico?start_date=2019-01-01T00:00&end_date=2019-01-31T23:59&time_trunc=day';

  // Función para obtener el coste diario de electricidad
  Future<Map<String, dynamic>?> obtenerCosteDiarioElectricidad() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Decodifica la respuesta JSON
        Map<String, dynamic> data = json.decode(response.body);

        // Extraer valores específicos de los datos
        var balance = data['data'];
        var lastUpdate = balance['attributes']['last-update'];
        var description = balance['attributes']['description'];

        print('Última actualización: $lastUpdate');
        print('Descripción: $description');

        // Procesar más datos como valores de generación según tipo (por ejemplo, Hidráulica, Eólica, etc.)
        var included = data['included'];

        included.forEach((item) {
          if (item['type'] == 'Renovable') {
            print('Tipo de energía renovable: ${item['attributes']['title']}');
            var content = item['attributes']['content'];
            content.forEach((energySource) {
              print('Fuente: ${energySource['attributes']['title']}');
              var values = energySource['attributes']['values'];
              values.forEach((value) {
                print('Valor: ${value['value']} kWh, Fecha: ${value['datetime']}');
              });
            });
          }
        });

        return data;
      } else {
        throw Exception('Error al obtener los datos');
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
