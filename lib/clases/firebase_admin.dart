import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

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

  Future<void> subirImagenPerfil(File imagen) async {
    try {
      User? usuario = _auth.currentUser;
      if (usuario == null) {
        throw Exception("Usuario no autenticado");
      }

      final String uid = usuario.uid;
      final Reference storageRef = FirebaseStorage.instance.ref().child('imagenes/$uid.jpg');
      UploadTask uploadTask = storageRef.putFile(imagen);

      final TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      // Guarda la URL en Firestore
      await guardarUsuario({'imagenPerfil': downloadUrl});

      print("Imagen subida y URL guardada: $downloadUrl");
    } catch (e) {
      print("Error al subir la imagen: $e");
      throw Exception("Error al subir la imagen");
    }
  }

// Aquí puedes agregar más métodos para interactuar con Firebase si es necesario.
}
