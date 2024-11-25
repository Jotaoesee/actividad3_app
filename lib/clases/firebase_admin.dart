import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAdmin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Inicialización de Firebase (por si es necesario hacer algún setup adicional)
  Future<void> inicializarFirebase() async {
    // Si es necesario, se pueden añadir configuraciones de Firebase aquí
  }

  // Función para guardar un usuario en Firestore
  Future<void> guardarUsuario(Map<String, dynamic> usuarioData) async {
    try {
      // Obtén el usuario actual autenticado
      User? usuario = _auth.currentUser;
      if (usuario == null) {
        throw Exception("Usuario no autenticado");
      }

      // Referencia al documento del usuario en Firestore (usando su UID)
      DocumentReference usuarioRef = _firestore.collection('usuarios').doc(usuario.uid);

      // Guardar los datos del usuario en Firestore
      await usuarioRef.set(usuarioData);

      print("Usuario guardado exitosamente");
    } catch (e) {
      print("Error al guardar usuario: $e");
      throw Exception("Error al guardar usuario");
    }
  }

// Aquí puedes agregar más métodos para interactuar con Firebase si es necesario.
}
