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

  Future<Map<String, dynamic>> obtenerUsuario() async {
    try {
      // Obtén el usuario actual autenticado
      User? usuario = _auth.currentUser;
      if (usuario == null) {
        throw Exception("Usuario no autenticado");
      }

      // Referencia al documento del usuario en Firestore (usando su UID)
      DocumentReference usuarioRef = _firestore.collection('usuarios').doc(usuario.uid);

      // Obtener el documento del usuario
      DocumentSnapshot snapshot = await usuarioRef.get();

      // Verificar si el documento existe
      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>;
      } else {
        throw Exception("No se encontraron datos del usuario");
      }
    } catch (e) {
      print("Error al obtener los datos del usuario: $e");
      throw Exception("Error al obtener los datos del usuario");
    }
  }

  // Método para obtener el nombre del usuario
  Future<String?> obtenerNombreUsuario() async {
    try {
      Map<String, dynamic> usuarioData = await obtenerUsuario(); // Llama al método obtenerUsuario
      return usuarioData['nombre']; // Devuelve el nombre del usuario desde Firestore (asegurándote de que esté almacenado como 'nombre')
    } catch (e) {
      print("Error al obtener el nombre del usuario: $e");
      return null;
    }
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
}
