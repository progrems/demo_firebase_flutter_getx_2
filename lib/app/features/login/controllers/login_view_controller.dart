part of '../views/screens/login_view_screen.dart';

class LoginViewController extends GetxController with ValidationInputMixin {
  LoginViewController({
    AuthService? authService,
    FirestoreService? firestoreService,
  }) : _authService = authService ?? AuthService(),
       _firestoreService = firestoreService ?? FirestoreService();

  final AuthService _authService;
  final FirestoreService _firestoreService;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final RxBool isLoading = false.obs;
  final RxBool isPasswordResetLoading = false.obs;

  Future<void> login() async {
    final validationError = _validate();
    if (validationError != null) {
      ScaffoldService.warning('Formulaire incomplet', validationError);
      return;
    }

    isLoading.value = true;
    try {
      await _authService.loginWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      await _authService.reloadCurrentUser();

      final firebaseUser = _authService.getCurrentUser();
      if (firebaseUser == null) {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'Aucun utilisateur connecté.',
        );
      }

      if (!firebaseUser.emailVerified) {
        await _authService.signOut();
        ScaffoldService.warning(
          'Email non confirmé',
          'Veuillez confirmer votre adresse email avant de vous connecter.',
        );
        return;
      }

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

      Get.find<RootController>().closeAuthDialog();
      _clearFields();
      Get.offAllNamed(Routes.home);
    } on FirebaseAuthException catch (error) {
      ScaffoldService.error('Connexion impossible', _authErrorMessage(error));
    } on FirebaseException catch (error) {
      ScaffoldService.error(
        'Connexion impossible',
        _firebaseErrorMessage(error),
      );
    } catch (_) {
      ScaffoldService.error(
        'Connexion impossible',
        'Une erreur est survenue. Réessayez plus tard.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendPasswordResetEmail() async {
    final validationError = validateEmail(emailController.text);
    if (validationError != null) {
      ScaffoldService.warning(
        'Email requis',
        'Entrez votre email avant de demander la récupération du mot de passe.',
      );
      return;
    }

    isPasswordResetLoading.value = true;
    try {
      await _authService.sendPasswordResetEmail(emailController.text);
      ScaffoldService.success(
        'Email envoyé',
        'Si un compte existe avec cet email, un lien de réinitialisation a été envoyé.',
      );
    } on FirebaseAuthException catch (error) {
      ScaffoldService.error(
        'Envoi impossible',
        _passwordResetErrorMessage(error),
      );
    } catch (_) {
      ScaffoldService.error(
        'Envoi impossible',
        'Une erreur est survenue. Réessayez plus tard.',
      );
    } finally {
      isPasswordResetLoading.value = false;
    }
  }

  void showRegisterForm() {
    Get.find<RootController>().showRegisterForm();
  }

  String? _validate() {
    return validateEmail(emailController.text) ??
        validatePassword(passwordController.text);
  }

  String _authErrorMessage(FirebaseAuthException error) {
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
    emailController.clear();
    passwordController.clear();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
