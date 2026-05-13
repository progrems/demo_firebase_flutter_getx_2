import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import 'firestore_service.dart';

class FirestorageService {
  FirestorageService({
    FirebaseStorage? firebaseStorage,
    FirebaseAuth? firebaseAuth,
    FirestoreService? firestoreService,
  }) : _storage = firebaseStorage ?? FirebaseStorage.instance,
       _auth = firebaseAuth ?? FirebaseAuth.instance,
       _firestoreService = firestoreService ?? FirestoreService();

  final FirebaseStorage _storage;
  final FirebaseAuth _auth;
  final FirestoreService _firestoreService;

  // Envoie l'image choisie avec FilePicker vers Firebase Storage.
  // Storage stocke le fichier et retourne une URL de téléchargement.
  Future<String?> uploadFile(PlatformFile file) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        if (kDebugMode) {
          print('Erreur : Aucun utilisateur connecté');
        }
        return null;
      }

      final bytes = file.bytes;
      if (bytes == null) {
        if (kDebugMode) {
          print('Erreur : Le fichier sélectionné ne contient aucune donnée');
        }
        return null;
      }

      final uid = currentUser.uid;
      final extension = file.extension ?? 'jpg';
      // Chaque utilisateur a son propre dossier dans Storage.
      final path = 'users/$uid/images/photo_de_profil.$extension';

      if (kDebugMode) {
        print('Chemin du fichier : $path');
      }

      final reference = _storage.ref(path);
      // putData envoie les bytes du fichier image dans Firebase Storage.
      final uploadTask = await reference.putData(
        bytes,
        SettableMetadata(contentType: 'image/$extension'),
      );

      // getDownloadURL donne le lien que Firestore gardera dans profileImageUrl.
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      if (kDebugMode) {
        print('URL de téléchargement : $downloadUrl');
      }

      await _firestoreService.updateUserProfileImage(downloadUrl);

      return downloadUrl;
    } on FirebaseException catch (error) {
      if (kDebugMode) {
        print('Erreur Firebase Storage : ${error.message}');
      }
      return null;
    } catch (error) {
      if (kDebugMode) {
        print('Erreur lors de l’upload de l’image : $error');
      }
      return null;
    }
  }
}
