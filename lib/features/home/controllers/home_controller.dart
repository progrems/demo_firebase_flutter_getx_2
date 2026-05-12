import 'package:get/get.dart';

import '../../../config/routes/app_routes.dart';
import '../../../utils/services/firebase_auth_service.dart';
import '../../../utils/services/firestore_service.dart';
import '../../../utils/ui/app_snackbar.dart';
import '../../auth/models/user_model.dart';

// Controller de Home : charge le profil utilisateur et gère la déconnexion.
class HomeController extends GetxController {
  HomeController({
    required FirebaseAuthService authService,
    required FirestoreService firestoreService,
  }) : _authService = authService,
       _firestoreService = firestoreService;

  final FirebaseAuthService _authService;
  final FirestoreService _firestoreService;

  // Rxn signifie valeur réactive nullable : au début, user peut être null.
  final Rxn<UserModel> user = Rxn<UserModel>();

  // Etat de chargement affiché par HomeView.
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Dès l'arrivée sur Home, on charge les informations utilisateur.
    loadUser();
  }

  Future<void> loadUser() async {
    isLoading.value = true;
    try {
      // Recharge Firebase Auth pour avoir un emailVerified à jour.
      await _authService.reloadCurrentUser();
      final firebaseUser = _authService.getCurrentUser();

      // Sécurité supplémentaire : même si le middleware existe, Home vérifie aussi.
      if (firebaseUser == null || !firebaseUser.emailVerified) {
        await _authService.signOut();
        Get.offAllNamed(AppRoutes.account);
        return;
      }

      // Lecture du profil dans Firestore avec le uid Firebase.
      final userData = await _firestoreService.getUserByUid(firebaseUser.uid);

      if (userData == null) {
        // Cas rare : l'utilisateur existe dans Auth mais pas dans Firestore.
        // On crée un profil minimal pour éviter une page Home vide.
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
        // Si le document existe, on synchronise emailVerified à true.
        await _firestoreService.updateUserEmailVerified(firebaseUser.uid, true);
        user.value = userData.copyWith(emailVerified: true);
      }
    } catch (_) {
      AppSnackbar.error(
        'Chargement impossible',
        'Impossible de récupérer les informations utilisateur.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    // Déconnexion Firebase, nettoyage local, puis retour à la page Compte.
    await _authService.signOut();
    user.value = null;
    Get.offAllNamed(AppRoutes.account);
  }
}
