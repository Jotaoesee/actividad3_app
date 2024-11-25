
import 'firebase_admin.dart';
import 'http_admin.dart';

class DataHolder {
  // Singleton para que haya una única instancia de DataHolder
  static final DataHolder _instance = DataHolder._internal();

  // Constructor privado
  DataHolder._internal() {
    _firebaseAdmin = FirebaseAdmin(); // Inicializa FirebaseAdmin
    _httpAdmin = HttpAdmin();         // Inicializa HttpAdmin
  }

  // Método para obtener la instancia
  factory DataHolder() {
    return _instance;
  }

  // Instancias de los servicios
  late final FirebaseAdmin _firebaseAdmin;
  late final HttpAdmin _httpAdmin;

  // Getters para acceder a los servicios
  FirebaseAdmin get firebaseAdmin => _firebaseAdmin;
  HttpAdmin get httpAdmin => _httpAdmin;

  // Método para inicializar datos adicionales si es necesario
  Future<void> inicializarServicios() async {
    // Por ejemplo, inicializar FirebaseAdmin con configuración específica
    await _firebaseAdmin.inicializarFirebase();

  }
}
