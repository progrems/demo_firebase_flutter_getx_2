import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/helpers/validators.dart';
import '../../../utils/services/firebase_auth_service.dart';
import '../../../utils/services/firestore_service.dart';
import '../../../utils/ui/app_snackbar.dart';
import '../models/user_model.dart';
import 'auth_controller.dart';

class RegisterController extends GetxController {
  // Les services Firebase sont injectés pour séparer la logique métier
  // de l'interface utilisateur.
  RegisterController({
    required FirebaseAuthService authService,
    required FirestoreService firestoreService,
  }) : _authService = authService,
       _firestoreService = firestoreService;

  final FirebaseAuthService _authService;
  final FirestoreService _firestoreService;

  // Controllers reliés aux champs du formulaire Inscription.
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Etat réactif pour bloquer le bouton pendant la création du compte.
  final RxBool isLoading = false.obs;

  Future<void> register() async {
    // Validation locale avant Firebase : champs obligatoires, email,
    // mot de passe et confirmation.
    final validationError = _validate();
    if (validationError != null) {
      AppSnackbar.warning('Formulaire incomplet', validationError);
      return;
    }

    isLoading.value = true;
    try {
      // 1. Création du compte dans Firebase Authentication.
      final credential = await _authService.registerWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Firebase renvoie l'utilisateur créé dans credential.user.
      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw FirebaseAuthException(
          code: 'registration-failed',
          message: 'Création du compte impossible.',
        );
      }

      // On ajoute le nom complet dans le profil Firebase Auth.
      await firebaseUser.updateDisplayName(fullNameController.text.trim());

      // 2. Envoi du lien de confirmation par email.
      await _authService.sendEmailVerification();

      // 3. Création du modèle à stocker dans Firestore.
      final user = UserModel(
        uid: firebaseUser.uid,
        fullName: fullNameController.text.trim(),
        email: emailController.text.trim(),
        emailVerified: firebaseUser.emailVerified,
        createdAt: DateTime.now(),
      );

      // 4. Sauvegarde dans Firestore : collection users, document = uid.
      await _firestoreService.createUser(user);

      // 5. On déconnecte l'utilisateur tant que son email n'est pas confirmé.
      await _authService.signOut();

      _clearFields();

      // Après inscription, on reste dans le même popup et on revient à Connexion.
      Get.find<AuthController>().showLoginForm();
      AppSnackbar.success(
        'Compte créé',
        'Un email de confirmation vous a été envoyé.',
      );
    } on FirebaseAuthException catch (error) {
      await _signOutAfterFailure();
      AppSnackbar.error('Inscription impossible', _authErrorMessage(error));
    } catch (_) {
      await _signOutAfterFailure();
      AppSnackbar.error(
        'Inscription impossible',
        'Une erreur est survenue. Réessayez plus tard.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  String? _validate() {
    // L'opérateur ?? retourne la première erreur non nulle.
    return Validators.requiredField(fullNameController.text, 'Nom complet') ??
        Validators.email(emailController.text) ??
        Validators.password(passwordController.text) ??
        Validators.confirmPassword(
          passwordController.text,
          confirmPasswordController.text,
        );
  }

  String _authErrorMessage(FirebaseAuthException error) {
    // Traduction des erreurs Firebase en messages lisibles.
    switch (error.code) {
      case 'email-already-in-use':
        return 'Cet email est déjà utilisé.';
      case 'invalid-email':
        return 'Email invalide.';
      case 'weak-password':
        return 'Le mot de passe est trop faible.';
      case 'operation-not-allowed':
        return 'La connexion par email/mot de passe est désactivée.';
      case 'network-request-failed':
        return 'Problème réseau. Vérifiez votre connexion.';
      default:
        return error.message ?? 'Inscription impossible.';
    }
  }

  void _clearFields() {
    fullNameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  Future<void> _signOutAfterFailure() async {
    // Si un utilisateur a été créé/connecté avant une erreur Firestore,
    // on le déconnecte pour ne pas lui donner accès à Home.
    if (_authService.getCurrentUser() != null) {
      await _authService.signOut();
    }
  }

  @override
  void onClose() {
    // Nettoyage des controllers des champs du formulaire.
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
