import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/mixins/validation_input_mixin.dart';
import '../../../utils/models/user_model.dart';
import '../../../utils/services/scaffold_service.dart';
import '../../../utils/services/src/auth_service.dart';
import '../../../utils/services/src/firestore_service.dart';
import '../../root/controllers/root_controller.dart';

class RegisterViewController extends GetxController with ValidationInputMixin {
  RegisterViewController({
    required AuthService authService,
    required FirestoreService firestoreService,
  }) : _authService = authService,
       _firestoreService = firestoreService;

  final AuthService _authService;
  final FirestoreService _firestoreService;

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final RxBool isLoading = false.obs;

  Future<void> register() async {
    final validationError = _validate();
    if (validationError != null) {
      ScaffoldService.warning('Formulaire incomplet', validationError);
      return;
    }

    isLoading.value = true;
    try {
      final credential = await _authService.registerWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw FirebaseAuthException(
          code: 'registration-failed',
          message: 'Création du compte impossible.',
        );
      }

      await firebaseUser.updateDisplayName(fullNameController.text.trim());
      await _authService.sendEmailVerification();

      final user = UserModel(
        uid: firebaseUser.uid,
        fullName: fullNameController.text.trim(),
        email: emailController.text.trim(),
        emailVerified: firebaseUser.emailVerified,
        createdAt: DateTime.now(),
      );

      await _firestoreService.createUser(user);
      await _authService.signOut();

      _clearFields();
      Get.find<RootController>().showLoginForm();
      ScaffoldService.success(
        'Compte créé',
        'Un email de confirmation vous a été envoyé.',
      );
    } on FirebaseAuthException catch (error) {
      await _signOutAfterFailure();
      ScaffoldService.error('Inscription impossible', _authErrorMessage(error));
    } on FirebaseException catch (error) {
      await _signOutAfterFailure();
      ScaffoldService.error(
        'Inscription impossible',
        _firebaseErrorMessage(error),
      );
    } catch (_) {
      await _signOutAfterFailure();
      ScaffoldService.error(
        'Inscription impossible',
        'Une erreur est survenue. Réessayez plus tard.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  void showLoginForm() {
    Get.find<RootController>().showLoginForm();
  }

  String? _validate() {
    return validateRequired(fullNameController.text, 'Nom complet') ??
        validateEmail(emailController.text) ??
        validatePassword(passwordController.text) ??
        validateConfirmPassword(
          passwordController.text,
          confirmPasswordController.text,
        );
  }

  String _authErrorMessage(FirebaseAuthException error) {
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

  String _firebaseErrorMessage(FirebaseException error) {
    switch (error.code) {
      case 'permission-denied':
        return 'Accès Firestore refusé. Vérifiez les règles de sécurité.';
      case 'unavailable':
        return 'Service Firebase indisponible. Réessayez plus tard.';
      case 'network-request-failed':
        return 'Problème réseau. Vérifiez votre connexion.';
      default:
        return error.message ?? 'Erreur Firebase inattendue.';
    }
  }

  void _clearFields() {
    fullNameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  Future<void> _signOutAfterFailure() async {
    try {
      if (_authService.getCurrentUser() != null) {
        await _authService.signOut();
      }
    } catch (_) {
      // On ne masque pas l'erreur principale d'inscription avec une erreur
      // secondaire de déconnexion.
    }
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
