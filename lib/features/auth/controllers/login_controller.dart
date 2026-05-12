import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/routes/app_routes.dart';
import '../../../utils/helpers/validators.dart';
import '../../../utils/services/firebase_auth_service.dart';
import '../../../utils/services/firestore_service.dart';
import '../../../utils/ui/app_snackbar.dart';
import '../models/user_model.dart';
import 'auth_controller.dart';

class LoginController extends GetxController {
  // Les services sont injectés depuis AppPages. Cela évite d'appeler
  // Firebase directement depuis la vue auth_dialog.dart.
  LoginController({
    required FirebaseAuthService authService,
    required FirestoreService firestoreService,
  }) : _authService = authService,
       _firestoreService = firestoreService;

  final FirebaseAuthService _authService;
  final FirestoreService _firestoreService;

  // Controllers reliés aux champs Email et Mot de passe du formulaire.
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Etats réactifs utilisés par le popup pour afficher les chargements.
  final RxBool isLoading = false.obs;
  final RxBool isPasswordResetLoading = false.obs;

  Future<void> login() async {
    // On valide les champs avant d'envoyer une requête à Firebase.
    final validationError = _validate();
    if (validationError != null) {
      AppSnackbar.warning('Formulaire incomplet', validationError);
      return;
    }

    isLoading.value = true;
    try {
      // Connexion avec Firebase Authentication.
      await _authService.loginWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Recharge l'utilisateur pour récupérer le vrai état de emailVerified.
      // C'est utile après que l'utilisateur a cliqué sur le lien reçu par email.
      await _authService.reloadCurrentUser();

      final firebaseUser = _authService.getCurrentUser();
      if (firebaseUser == null) {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'Aucun utilisateur connecté.',
        );
      }

      // Si l'email n'est pas confirmé, l'accès à Home est bloqué.
      // On déconnecte immédiatement l'utilisateur.
      if (!firebaseUser.emailVerified) {
        await _authService.signOut();
        AppSnackbar.warning(
          'Email non confirmé',
          'Veuillez confirmer votre adresse email avant de vous connecter.',
        );
        return;
      }

      // On récupère le profil Firestore avec le uid Firebase.
      // Si le document manque, on le recrée avec les infos disponibles.
      final storedUser = await _firestoreService.getUserByUid(firebaseUser.uid);
      if (storedUser == null) {
        await _firestoreService.createUser(
          UserModel(
            uid: firebaseUser.uid,
            fullName: firebaseUser.displayName ?? 'Utilisateur',
            email: firebaseUser.email ?? emailController.text.trim(),
            emailVerified: true,
            createdAt: DateTime.now(),
          ),
        );
      } else {
        await _firestoreService.updateUserEmailVerified(firebaseUser.uid, true);
      }

      // Email vérifié : on ferme le popup et on redirige vers Home.
      Get.find<AuthController>().closeDialog();
      _clearFields();
      Get.offAllNamed(AppRoutes.home);
    } on FirebaseAuthException catch (error) {
      AppSnackbar.error('Connexion impossible', _authErrorMessage(error));
    } catch (_) {
      AppSnackbar.error(
        'Connexion impossible',
        'Une erreur est survenue. Réessayez plus tard.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  String? _validate() {
    // Retourne la première erreur trouvée, sinon null.
    return Validators.email(emailController.text) ??
        Validators.password(passwordController.text);
  }

  Future<void> sendPasswordResetEmail() async {
    final validationError = Validators.email(emailController.text);
    if (validationError != null) {
      AppSnackbar.warning(
        'Email requis',
        'Entrez votre email avant de demander la récupération du mot de passe.',
      );
      return;
    }

    isPasswordResetLoading.value = true;
    try {
      // L'email utilisé est celui saisi dans le formulaire Connexion.
      await _authService.sendPasswordResetEmail(emailController.text);
      AppSnackbar.success(
        'Email envoyé',
        'Si un compte existe avec cet email, un lien de réinitialisation a été envoyé.',
      );
    } on FirebaseAuthException catch (error) {
      AppSnackbar.error('Envoi impossible', _passwordResetErrorMessage(error));
    } catch (_) {
      AppSnackbar.error(
        'Envoi impossible',
        'Une erreur est survenue. Réessayez plus tard.',
      );
    } finally {
      isPasswordResetLoading.value = false;
    }
  }

  String _authErrorMessage(FirebaseAuthException error) {
    // Transforme les codes Firebase en messages simples pour l'utilisateur.
    switch (error.code) {
      case 'invalid-email':
        return 'Email invalide.';
      case 'user-disabled':
        return 'Ce compte a été désactivé.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Email ou mot de passe incorrect.';
      case 'too-many-requests':
        return 'Trop de tentatives. Réessayez plus tard.';
      case 'network-request-failed':
        return 'Problème réseau. Vérifiez votre connexion.';
      default:
        return error.message ?? 'Connexion impossible.';
    }
  }

  String _passwordResetErrorMessage(FirebaseAuthException error) {
    // Messages dédiés à la récupération du mot de passe.
    switch (error.code) {
      case 'invalid-email':
        return 'Email invalide.';
      case 'user-not-found':
        return 'Aucun compte ne correspond à cet email.';
      case 'too-many-requests':
        return 'Trop de demandes. Réessayez plus tard.';
      case 'network-request-failed':
        return 'Problème réseau. Vérifiez votre connexion.';
      default:
        return error.message ?? 'Impossible d’envoyer le lien.';
    }
  }

  void _clearFields() {
    emailController.clear();
    passwordController.clear();
  }

  @override
  void onClose() {
    // Nettoyage des TextEditingController pour éviter les fuites mémoire.
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
