import 'package:cloud_firestore/cloud_firestore.dart';

import '../../constants/api_path/firebase_collections.dart';
import '../../features/auth/models/user_model.dart';

// Service responsable uniquement de Cloud Firestore.
// Il isole les détails Firestore des controllers.
class FirestoreService {
  FirestoreService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  // Référence vers la collection users. Le nom vient des constantes.
  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection(FirebaseCollections.users);

  // Crée ou remplace le document users/{uid}.
  Future<void> createUser(UserModel user) {
    return _usersCollection.doc(user.uid).set(user.toMap());
  }

  // Récupère le profil Firestore d'un utilisateur grâce à son uid Firebase.
  Future<UserModel?> getUserByUid(String uid) async {
    final snapshot = await _usersCollection.doc(uid).get();
    final data = snapshot.data();

    if (!snapshot.exists || data == null) {
      return null;
    }

    return UserModel.fromMap(data);
  }

  // Met à jour le statut emailVerified dans Firestore après confirmation.
  Future<void> updateUserEmailVerified(String uid, bool emailVerified) {
    return _usersCollection.doc(uid).update({'emailVerified': emailVerified});
  }
}
