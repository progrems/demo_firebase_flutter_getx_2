import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared_components/styles/app_text_styles.dart';
import '../../../shared_components/widgets/custom_button.dart';
import '../../../shared_components/widgets/custom_text_field.dart';
import '../controllers/auth_controller.dart';
import '../controllers/login_controller.dart';
import '../controllers/register_controller.dart';

class AuthDialog extends StatelessWidget {
  const AuthDialog({super.key});

  @override
  Widget build(BuildContext context) {
    // AuthController décide si le popup montre Connexion ou Inscription.
    final authController = Get.find<AuthController>();

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Obx(
            // Obx écoute isLoginMode. Quand l'utilisateur clique sur
            // "Créer un compte" ou "Se connecter", seul le contenu change.
            () => AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: authController.isLoginMode.value
                  ? const _LoginForm(key: ValueKey('login-form'))
                  : const _RegisterForm(key: ValueKey('register-form')),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    // La vue récupère les controllers, mais ne contient pas la logique Firebase.
    final authController = Get.find<AuthController>();
    final loginController = Get.find<LoginController>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Connexion', style: AppTextStyles.dialogTitle),
        const SizedBox(height: 22),
        CustomTextField(
          controller: loginController.emailController,
          label: 'Email',
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 14),
        CustomTextField(
          controller: loginController.passwordController,
          label: 'Mot de passe',
          prefixIcon: Icons.lock_outline,
          obscureText: true,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => loginController.login(),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Obx(
            // Utilise l'email déjà saisi pour envoyer un lien de réinitialisation.
            () => TextButton(
              onPressed: loginController.isPasswordResetLoading.value
                  ? null
                  : loginController.sendPasswordResetEmail,
              child: Text(
                loginController.isPasswordResetLoading.value
                    ? 'Envoi en cours...'
                    : 'Mot de passe oublié ?',
              ),
            ),
          ),
        ),
        const SizedBox(height: 22),
        Obx(
          // Le bouton se bloque et affiche un loader pendant l'appel Firebase.
          () => CustomButton(
            label: 'Se connecter',
            icon: Icons.login,
            isLoading: loginController.isLoading.value,
            onPressed: loginController.login,
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          // Pas de nouvelle page : on change l'état du même popup.
          onPressed: authController.showRegisterForm,
          child: const Text('Créer un compte'),
        ),
      ],
    );
  }
}

class _RegisterForm extends StatelessWidget {
  const _RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    // Formulaire d'inscription affiché dans le même AuthDialog.
    final authController = Get.find<AuthController>();
    final registerController = Get.find<RegisterController>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Inscription', style: AppTextStyles.dialogTitle),
        const SizedBox(height: 22),
        CustomTextField(
          controller: registerController.fullNameController,
          label: 'Nom complet',
          prefixIcon: Icons.person_outline,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 14),
        CustomTextField(
          controller: registerController.emailController,
          label: 'Email',
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 14),
        CustomTextField(
          controller: registerController.passwordController,
          label: 'Mot de passe',
          prefixIcon: Icons.lock_outline,
          obscureText: true,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 14),
        CustomTextField(
          controller: registerController.confirmPasswordController,
          label: 'Confirmation mot de passe',
          prefixIcon: Icons.lock_reset_outlined,
          obscureText: true,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => registerController.register(),
        ),
        const SizedBox(height: 22),
        Obx(
          // Pendant la création du compte, le bouton montre un chargement.
          () => CustomButton(
            label: "S'inscrire",
            icon: Icons.person_add_alt_1_outlined,
            isLoading: registerController.isLoading.value,
            onPressed: registerController.register,
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          // Retour vers Connexion sans fermer le popup.
          onPressed: authController.showLoginForm,
          child: const Text('Déjà un compte ? Se connecter'),
        ),
      ],
    );
  }
}
