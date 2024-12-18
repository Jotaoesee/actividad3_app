import 'dart:io';
import 'dart:typed_data';
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

  // Método para guardar los datos adicionales del usuario
  Future<void> guardarDatosAdicionales(String uid, Map<String, dynamic> usuarioData) async {
    try {
      User? usuario = _auth.currentUser;
      // Referencia al documento del usuario en Firestore
      DocumentReference usuarioRef = _firestore.collection('usuarios').doc(usuario?.uid);

      // Referencia a la subcolección "datos_adicionales" usando el uid del usuario
      final subcoleccionRef =  usuarioRef.collection('datos_adicionales').doc(uid); // Usamos el uid como id del documento

      // Verifica si el documento de datos adicionales ya existe
      DocumentSnapshot snapshot = await subcoleccionRef.get();
      if (snapshot.exists) {
        // Si el documento existe, usamos 'update' para evitar sobrescribirlo
        await subcoleccionRef.update(usuarioData);
        print("Datos adicionales actualizados exitosamente");
      } else {
        // Si no existe, usamos 'set' para crearlo
        await subcoleccionRef.set(usuarioData);
        print("Datos adicionales guardados exitosamente");
      }
    } catch (e) {
      print("Error al guardar datos adicionales del usuario: $e");
      throw Exception("Error al guardar datos adicionales: $e");
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

  // Método para mapear un usuario con valores seguros
  Usuario mapearUsuario(QueryDocumentSnapshot usuario) {
    final data = usuario.data() as Map<String, dynamic>;
    return Usuario(
      id: usuario.id,
      nombre: data['nombre'] ?? 'Sin nombre',
      apellido: data['apellido'] ?? 'Sin apellido',
      fechaNacimiento: data['fecha_nacimiento'] ?? 'Sin fecha',
      telefono: data['telefono'] ?? 'Sin teléfono',
      ciudad: data['ciudad'] ?? 'Sin ciudad',
      fotoPerfil: data['fotoPerfil'],
    );
  }

  // Función para subir la imagen de perfil
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

  // Función para subir imagen de perfil usando bytes
  Future<void> subirImagenPerfilBytes(Uint8List imagenBytes) async {
    try {
      User? usuario = _auth.currentUser;
      if (usuario == null) {
        throw Exception("Usuario no autenticado");
      }
      final String uid = usuario.uid;
      final Reference storageRef = FirebaseStorage.instance.ref().child('imagenes/$uid.jpg');
      UploadTask uploadTask = storageRef.putData(imagenBytes);

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


  // Método para guardar los ajustes del usuario
  Future<void> guardarAjustes(String uid, Map<String, dynamic> ajustesData) async {
    try {
      // Referencia al documento de ajustes del usuario en Firestore
      DocumentReference ajustesRef = _firestore.collection('ajustes').doc(uid);

      // Guardar o actualizar los ajustes del usuario en Firestore
      await ajustesRef.set(ajustesData);
      print("Ajustes guardados exitosamente");
    } catch (e) {
      print("Error al guardar ajustes: $e");
      throw Exception("Error al guardar ajustes");
    }
  }

  // Método para buscar usuarios por nombre usando el índice
  Future<List<Usuario>> buscarUsuariosPorNombre(String nombre) async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('usuarios')
          .where('nombre', isGreaterThanOrEqualTo: nombre)
          .where('nombre', isLessThan: nombre + 'z')
          .get();

      return querySnapshot.docs.map((doc) => mapearUsuario(doc)).toList();
    } catch (e) {
      print("Error al buscar usuarios por nombre: $e");
      throw Exception("Error al buscar usuarios por nombre: $e");
    }
  }

  // Método para obtener los ajustes del usuario
  Future<Map<String, dynamic>> obtenerAjustes(String uid) async {
    try {
      // Referencia al documento de ajustes del usuario en Firestore
      DocumentReference ajustesRef = _firestore.collection('ajustes').doc(uid);

      // Obtener el documento de ajustes del usuario
      DocumentSnapshot snapshot = await ajustesRef.get();

      // Verificar si el documento existe
      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>;
      } else {
        // Si no existen, retornamos un map vacío
        return {};
      }
    } catch (e) {
      print("Error al obtener los ajustes del usuario: $e");
      throw Exception("Error al obtener los ajustes del usuario");
    }
  }
}

// Clase para representar la información del usuario
class Usuario {
  final String id;
  final String nombre;
  final String apellido;
  final String fechaNacimiento;
  final String telefono;
  final String ciudad;
  final String? fotoPerfil;

  Usuario({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.fechaNacimiento,
    required this.telefono,
    required this.ciudad,
    this.fotoPerfil,
  });
}