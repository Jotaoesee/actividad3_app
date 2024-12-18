oTexto: 16.0,
        esquemaColor: 'Azul'
      };
      try {
         // Crea un documento en la colección "ajustes" usando el mismo id del usuario
         await admin.firestore()
         .collection('ajustes')
         .doc(userId)
         .set(defaultAjustes);

         console.log(`Ajustes creados para el usuario ${userId}`);
      } catch (error) {
        console.error("Error al crear ajustes:", error);
        // throw new functions.https.HttpsError('internal', 'Error al crear ajustes para usuario.');
      }
    });