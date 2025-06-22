📱 Mi Hub Personal: Conexiones, Utilidades y Notificaciones 🚀
Descripción del Proyecto
Mi Hub Personal: Conexiones, Utilidades y Notificaciones es una aplicación móvil desarrollada con Flutter que centraliza diversas funcionalidades para el usuario. Actúa como un centro personalizable donde los usuarios pueden gestionar su perfil detallado, interactuar con otros usuarios, personalizar la interfaz de la aplicación, y acceder a utilidades prácticas como el pronóstico del tiempo en tiempo real y datos sobre el balance eléctrico. La aplicación se integra profundamente con Firebase para la autenticación, base de datos (Firestore) y almacenamiento (Storage), además de utilizar Firebase Cloud Messaging (FCM) para la gestión de notificaciones.

El Problema que Resuelve
Mi Hub Personal busca ofrecer una experiencia de usuario enriquecida y centralizada, resolviendo las siguientes necesidades:

Gestión de identidad y perfil: Proporciona un sistema robusto para que los usuarios creen, editen y gestionen sus perfiles personales y datos adicionales.

Personalización de la experiencia: Permite a los usuarios adaptar la apariencia de la aplicación a sus preferencias individuales (temas, colores, tamaño de texto).

Acceso a información útil en un solo lugar: Consolida datos externos relevantes (clima, energía eléctrica) que normalmente se buscarían en aplicaciones separadas.

Comunicación y conexión: Facilita la exploración y conexión con otros usuarios dentro de la plataforma.

Notificaciones personalizadas: Prepara el terreno para mantener a los usuarios informados a través de notificaciones push relevantes.

¿Para Quién es Útil?
Este proyecto es ideal para:

Desarrolladores de Flutter: Como un ejemplo práctico de una aplicación completa que integra múltiples servicios de Firebase y APIs externas, además de ofrecer una UI personalizable.

Usuarios finales: Que buscan una aplicación multifuncional para gestionar su información personal y acceder a utilidades diarias.

Estudiantes y profesionales: Interesados en aprender sobre la construcción de aplicaciones Flutter de nivel medio con autenticación, base de datos NoSQL, almacenamiento de archivos, notificaciones y consumo de APIs externas.

✨ Características Destacadas
🔐 Autenticación Robusta con Firebase Auth:

Inicio de sesión y registro de usuarios mediante email y contraseña.

Manejo de errores y validación de formulario para una experiencia de usuario fluida.

Soporte para inicio de sesión con redes sociales (esqueleto, extensible).

👤 Gestión Integral de Perfiles:

Perfil Básico: Visualiza y edita información como nombre, apellido, teléfono, ciudad y fecha de nacimiento.

Datos Adicionales: Edita detalles extra como descripción, ocupación e intereses, almacenados en una subcolección de Firestore.

Fotos de Perfil: Sube y actualiza imágenes de perfil desde la galería o cámara, con soporte para web y móvil, almacenadas en Firebase Storage.

🎨 Personalización de la Interfaz (UI):

Alterna entre modo claro y modo oscuro.

Selecciona entre múltiples esquemas de color predefinidos (Azul, Verde, Rojo, Amarillo) para la UI.

Ajusta el tamaño del texto de la aplicación.

Todos los ajustes se guardan y cargan de forma persistente en Firestore.

🔔 Notificaciones Push con FCM:

Solicita permisos de notificación al usuario.

Registra y actualiza el token FCM del dispositivo en Firestore, identificando la plataforma (Android, iOS, Web, Desktop).

Preparada para recibir notificaciones en tiempo real.

👥 Directorio de Usuarios y Búsqueda:

Explora una lista o cuadrícula de otros usuarios registrados en la aplicación.

Funcionalidad de búsqueda por nombre para encontrar usuarios específicos.

⚡ Datos del Balance Eléctrico (Red Eléctrica de España):

Consulta datos históricos y relevantes sobre la generación y consumo de electricidad en España a través de la API de REE.

☀️ Pronóstico del Tiempo en Tiempo Real:

Obtiene la ubicación actual del usuario mediante geolocator.

Consulta el pronóstico del tiempo por hora (temperatura, humedad, punto de rocío) para la ubicación actual utilizando la API de Open-Meteo.com.

Permite "pull to refresh" para actualizar los datos del clima.

✨ Diseño y Navegación Intuitivos:

BottomNavigationBar para acceso rápido a Inicio, Perfil y Ajustes.

Drawer (menú lateral) con acceso a todas las secciones, incluyendo datos adicionales y el pronóstico del tiempo.

Uso de componentes personalizables (BotonPersonalizado) con efectos visuales al presionar y estilos consistentes.

🛠️ Tecnologías Utilizadas
Lenguaje de Programación: Dart

Framework de Desarrollo: Flutter

Backend como Servicio (BaaS): Google Firebase

Firebase Authentication: Gestión de usuarios (email/password, futura integración con OAuth).

Cloud Firestore: Base de datos NoSQL para perfiles de usuario, ajustes y datos adicionales.

Firebase Storage: Almacenamiento de fotos de perfil.

Firebase Cloud Messaging (FCM): Envío y recepción de notificaciones push.

Ubicación: geolocator

Peticiones HTTP: http

Selección de Imágenes: image_picker (móvil), image_picker_web (web)

Manejo de Fechas: intl

Iconos Adicionales: font_awesome_flutter

Manejo de Plataformas Web (User Agent): universal_html

Animaciones: animate_do

🚀 Cómo Instalar y Ejecutar
Para poner en marcha Mi Hub Personal en tu entorno local, necesitarás configurar tu entorno Flutter y un proyecto de Firebase.

Prerrequisitos
Flutter SDK: Se recomienda la última versión estable.

Un editor de código (VS Code, Android Studio).

Un dispositivo o emulador configurado para ejecutar aplicaciones Flutter.

Una Cuenta de Google y un Proyecto de Firebase:

Crea un proyecto en la Consola de Firebase.

Configura tu aplicación Flutter con Firebase siguiendo la documentación oficial.

Habilita los servicios de Authentication (Email/Password), Firestore Database, y Cloud Storage.

Asegúrate de configurar las reglas de seguridad de Firestore y Storage para permitir las operaciones de lectura/escritura necesarias para los usuarios autenticados.

Configura Firebase Cloud Messaging para tu plataforma (Android/iOS/Web) si planeas probar las notificaciones.

Pasos de Instalación
Clona el repositorio:

git clone https://github.com/tu_usuario/mi_hub_personal.git
cd mi_hub_personal

(Nota: Reemplaza https://github.com/tu_usuario/mi_hub_personal.git con la URL real de tu repositorio y mi_hub_personal con el nombre de tu proyecto en tu máquina si es diferente.)

Instala las dependencias de Flutter:

flutter pub get

Configuración de Firebase para Flutter:
Asegúrate de que tu proyecto Flutter esté correctamente conectado a tu proyecto de Firebase. Esto generalmente implica:

Ejecutar flutterfire configure.

Tener el archivo google-services.json (Android) y/o GoogleService-Info.plist (iOS) en las ubicaciones correctas.

Permisos de Ubicación (Android/iOS):

Android: Añade los permisos necesarios en android/app/src/main/AndroidManifest.xml:

<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />

iOS: Añade las descripciones de uso de ubicación en ios/Runner/Info.plist:

<key>NSLocationWhenInUseUsageDescription</key>
<string>Esta app necesita su ubicación para obtener el pronóstico del tiempo.</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>Esta app necesita su ubicación para obtener el pronóstico del tiempo en segundo plano.</string>

Cómo Ejecutar la Aplicación
Ejecuta la aplicación:

flutter run

La aplicación se lanzará en el dispositivo o emulador que tengas configurado.

📈 Cómo Usar la Aplicación
Mi Hub Personal ofrece una experiencia completa desde el inicio de sesión hasta la exploración de funcionalidades.

Flujo Principal
Pantalla de Splash (Splash.dart): Es la primera pantalla que verás, con animaciones y una barra de progreso.

Inicio de Sesión / Registro (InicioSesion.dart / Registro.dart):

Inicia sesión con tu email y contraseña.

Si no tienes cuenta, regístrate y crea una nueva.

Las notificaciones push se configurarán automáticamente al iniciar sesión.

Pantalla de Inicio (Home.dart):

El dashboard principal con una BottomNavigationBar para navegar entre Inicio, Perfil y Ajustes.

También puedes acceder a otras secciones a través del Drawer (menú lateral).

Secciones de la Aplicación:

Inicio (Inicio.dart): Muestra una lista (o cuadrícula) de usuarios. Puedes buscar usuarios por nombre y alternar la vista.

Perfil (PerfilUsuario.dart): Visualiza y edita tu información personal (nombre, apellido, contacto, etc.). Puedes subir una foto de perfil y cerrar sesión desde aquí.

Ajustes (Ajuste.dart): Personaliza la apariencia de la app (modo oscuro, esquemas de color, tamaño de texto). Tus preferencias se guardarán.

Datos Adicionales (EditarDatosAdicionales.dart): Accede desde el Drawer para añadir una descripción, seleccionar intereses y especificar tu ocupación.

Tiempo (PantallaTiempo.dart): Accede desde el Drawer para ver el pronóstico del tiempo de tu ubicación actual.

Datos de Energía (a través de HttpAdmin): Aunque no hay una pantalla dedicada visible, la clase HttpAdmin te permite integrar futuras funcionalidades que muestren los datos de Red Eléctrica de España.
