import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

import '../../../config/routes/app_routes.dart';
import '../../../utils/models/user_model.dart';
import '../../../utils/services/scaffold_service.dart';
import '../../../utils/services/src/auth_service.dart';
import '../../../utils/services/src/firestorage_service.dart';
import '../../../utils/services/src/firestore_service.dart';

class HomeViewController extends GetxController {
  HomeViewController({
    required AuthService authService,
    required FirestoreService firestoreService,
  }) : _authService = authService,
       _firestoreService = firestoreService;

  final AuthService _authService;
  final FirestoreService _firestoreService;

  final Rxn<UserModel> user = Rxn<UserModel>();
  final RxBool isLoading = false.obs;
  final RxBool isUploadingProfileImage = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUser();
  }

  // Charge l'utilisateur connecté et récupère son profil depuis Firestore.
  Future<void> loadUser() async {
    isLoading.value = true;
    try {
      await _authService.reloadCurrentUser();
      final firebaseUser = _authService.getCurrentUser();

      if (firebaseUser == null || !firebaseUser.emailVerified) {
        await _authService.signOut();
        Get.offAllNamed(Routes.root);
        return;
      }

      final userData = await _firestoreService.getUserByUid(firebaseUser.uid);

      if (userData == null) {
        final fallbackUser = UserModel(
          uid: firebaseUser.uid,
          fullName: firebaseUser.displayName ?? 'Utilisateur',
          email: firebaseUser.email ?? '',
          emailVerified: true,
          createdAt: DateTime.now(),
        );
        await _firestoreService.createUser(fallbackUser);
        user.value = fallbackUser;
      } else {
        await _firestoreService.updateUserEmailVerified(firebaseUser.uid, true);
        user.value = userData.copyWith(emailVerified: true);
      }
    } on FirebaseAuthException catch (error) {
      ScaffoldService.error('Chargement impossible', _authErrorMessage(error));
    } on FirebaseException catch (error) {
      ScaffoldService.error(
        'Chargement impossible',
        _firebaseErrorMessage(error),
      );
    } catch (_) {
      ScaffoldService.error(
        'Chargement impossible',
        'Impossible de récupérer les informations utilisateur.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Ferme la session Firebase puis renvoie vers l'écran avec le bouton Compte.
  Future<void> logout() async {
    try {
      await _authService.signOut();
      user.value = null;
      Get.offAllNamed(Routes.root);
    } on FirebaseAuthException catch (error) {
      ScaffoldService.error('Déconnexion impossible', _authErrorMessage(error));
    } catch (_) {
      ScaffoldService.error(
        'Déconnexion impossible',
        'Une erreur est survenue pendant la déconnexion.',
      );
    }
  }

  // Choisit une image avec FilePicker, l'envoie dans Storage,
  // puis met à jour l'URL locale pour afficher la photo tout de suite.
  Future<void> pickAndUploadProfileImage() async {
    isUploadingProfileImage.value = true;
    try {
      final firebaseUser = _authService.getCurrentUser();
      if (firebaseUser == null) {
        ScaffoldService.warning(
          'Utilisateur introuvable',
          'Connectez-vous avant de modifier votre photo.',
        );
        return;
      }

      // FilePicker lit l'image choisie par l'utilisateur, ici avec les bytes.
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );

      if (result == null) {
        return;
      }

      final file = result.files.first;

      if (file.bytes == null) {
        ScaffoldService.error(
          'Image invalide',
          'Impossible de lire le fichier sélectionné.',
        );
        return;
      }

      // FirestorageService envoie le fichier et sauvegarde aussi l'URL dans Firestore.
      final imageUrl = await FirestorageService().uploadFile(file);

      if (imageUrl != null) {
        // Mise à jour locale pour que la Home affiche directement la nouvelle photo.
        user.value = user.value?.copyWith(profileImageUrl: imageUrl);
        ScaffoldService.success(
          'Photo mise à jour',
          'Votre photo de profil a été enregistrée.',
        );
      }
    } on FirebaseAuthException catch (error) {
      ScaffoldService.error('Upload impossible', _authErrorMessage(error));
    } on FirebaseException catch (error) {
      ScaffoldService.error('Upload impossible', _firebaseErrorMessage(error));
    } catch (_) {
      ScaffoldService.error(
        'Upload impossible',
        'Une erreur est survenue pendant l’envoi de la photo.',
      );
    } finally {
      isUploadingProfileImage.value = false;
    }
  }

  String _authErrorMessage(FirebaseAuthException error) {
    switch (error.code) {
      case 'network-request-failed':
        return 'Problème réseau. Vérifiez votre connexion.';
      case 'sign-out-unknown':
        return 'Impossible de fermer la session pour le moment.';
      default:
        return error.message ?? 'Erreur Firebase Auth inattendue.';
    }
  }

  String _firebaseErrorMessage(FirebaseException error) {
    switch (error.code) {
      case 'permission-denied':
        return 'Accès Firestore refusé. Vérifiez les règles de sécurité.';
      case 'unavailable':
        return 'Service Firebase indisponible. Réessayez plus tard.';
      default:
        return error.message ?? 'Erreur Firebase inattendue.';
    }
  }
}
