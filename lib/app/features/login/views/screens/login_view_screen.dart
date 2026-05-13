import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared_components/buttons/async_button.dart';
import '../../../../shared_components/text/title_text.dart';
import '../../../../shared_components/text_form_field/email_tff.dart';
import '../../../../shared_components/text_form_field/password_tff.dart';
import '../../controllers/login_view_controller.dart';

class LoginViewScreen extends GetView<LoginViewController> {
  const LoginViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // GetView donne accès au LoginViewController avec la variable controller.
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const TitleText('Connexion'),
        const SizedBox(height: 22),
        EmailTff(controller: controller.emailController),
        const SizedBox(height: 14),
        PasswordTff(
          controller: controller.passwordController,
          onSubmitted: (_) => controller.login(),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Obx(
            () => TextButton(
              onPressed: controller.isPasswordResetLoading.value
                  ? null
                  : controller.sendPasswordResetEmail,
              child: Text(
                controller.isPasswordResetLoading.value
                    ? 'Envoi en cours...'
                    : 'Mot de passe oublié ?',
              ),
            ),
          ),
        ),
        const SizedBox(height: 22),
        Obx(
          () => AsyncButton(
            label: 'Se connecter',
            icon: Icons.login,
            isLoading: controller.isLoading.value,
            // Le controller gère Firebase Auth et la vérification email.
            onPressed: controller.login,
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          // Ce lien ne change pas de page : il remplace Login par Register dans le popup.
          onPressed: controller.showRegisterForm,
          child: const Text('Créer un compte'),
        ),
      ],
    );
  }
}
