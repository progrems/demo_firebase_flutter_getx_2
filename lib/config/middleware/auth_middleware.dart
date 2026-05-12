import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    try {
      // currentUser vaut null si personne n'est connecté dans Firebase Auth.
      final user = FirebaseAuth.instance.currentUser;

      // Home est interdite si l'utilisateur n'existe pas ou si son email
      // n'a pas encore été confirmé.
      if (user == null || !user.emailVerified) {
        return const RouteSettings(name: AppRoutes.account);
      }

      // null signifie : aucune redirection, l'accès à Home est autorisé.
      return null;
    } catch (_) {
      // En cas d'erreur, on choisit la sécurité : retour à la page Compte.
      return const RouteSettings(name: AppRoutes.account);
    }
  }
}
