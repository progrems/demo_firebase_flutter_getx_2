part of '../app_service.dart';

class FirestoreService {
  FirestoreService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection(AppConstans.usersCollection);

  Future<void> createUser(UserModel user) async {
    try {
      await _usersCollection.doc(user.uid).set(user.toMap());
    } on FirebaseException {
      rethrow;
    } catch (error) {
      throw FirebaseException(
        plugin: 'cloud_firestore',
        code: 'create-user-unknown',
        message: error.toString(),
      );
    }
  }

  Future<UserModel?> getUserByUid(String uid) async {
    try {
      final snapshot = await _usersCollection.doc(uid).get();
      final data = snapshot.data();

      if (!snapshot.exists || data == null) {
        return null;
      }

      return UserModel.fromMap(data);
    } on FirebaseException {
      rethrow;
    } catch (error) {
      throw FirebaseException(
        plugin: 'cloud_firestore',
        code: 'get-user-unknown',
        message: error.toString(),
      );
    }
  }

  Future<void> updateUserEmailVerified(String uid, bool emailVerified) async {
    try {
      await _usersCollection.doc(uid).update({'emailVerified': emailVerified});
    } on FirebaseException {
      rethrow;
    } catch (error) {
      throw FirebaseException(
        plugin: 'cloud_firestore',
        code: 'update-user-unknown',
        message: error.toString(),
      );
    }
  }

  Future<void> updateUserProfileImage(String imageUrl) async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      // Firestore ne stocke pas l'image directement.
      // Il garde seulement l'URL Storage dans le champ profileImageUrl.
      await _usersCollection.doc(uid).update({'profileImageUrl': imageUrl});
    } catch (error) {
      debugPrint(
        'Erreur lors de la mise à jour de la photo de profil : $error',
      );
    }
  }
}
