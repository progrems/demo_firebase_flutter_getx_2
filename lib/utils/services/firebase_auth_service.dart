import 'package:firebase_auth/firebase_auth.dart';

// Service responsable uniquement de Firebase Authentication.
// Les controllers l'utilisent au lieu d'appeler FirebaseAuth.instance eux-mêmes.
class FirebaseAuthService {
  FirebaseAuthService({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;

  // Crée un compte Firebase Auth avec email et mot de passe.
  Future<UserCredential> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return _firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  // Envoie le lien de confirmation à l'utilisateur actuellement connecté.
  Future<void> sendEmailVerification() async {
    final user = _firebaseAuth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  // Connecte un utilisateur existant avec email et mot de passe.
  Future<UserCredential> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  // Envoie un email de réinitialisation. On ne récupère jamais l'ancien mot de passe.
  Future<void> sendPasswordResetEmail(String email) {
    return _firebaseAuth.sendPasswordResetEmail(email: email.trim());
  }

  // Recharge l'utilisateur depuis Firebase pour actualiser emailVerified.
  Future<void> reloadCurrentUser() async {
    await _firebaseAuth.currentUser?.reload();
  }

  // Retourne l'utilisateur connecté, ou null si personne n'est connecté.
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  // Déconnecte l'utilisateur de Firebase Auth.
  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }
}
