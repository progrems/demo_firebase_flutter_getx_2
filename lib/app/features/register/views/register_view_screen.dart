// ignore: unnecessary_library_name
library register_page;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared_components/buttons/async_button.dart';
import '../../../shared_components/text/title_text.dart';
import '../../../shared_components/text_form_field/email_tff.dart';
import '../../../shared_components/text_form_field/name_tff.dart';
import '../../../shared_components/text_form_field/password_tff.dart';
import '../../../utils/mixins/validation_input_mixin.dart';
import '../../../utils/models/user_model.dart';
import '../../../utils/services/app_service.dart';
import '../../../utils/services/scaffold_service.dart';
import '../../root/controllers/root_controller.dart';

// binding
part '../bindings/register_view_binding.dart';
// controller
part '../controllers/register_view_controller.dart';

class RegisterViewScreen extends GetView<RegisterViewController> {
  const RegisterViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // GetView donne accès au RegisterViewController avec la variable controller.
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const TitleText('Inscription'),
        const SizedBox(height: 22),
        NameTff(controller: controller.fullNameController),
        const SizedBox(height: 14),
        EmailTff(controller: controller.emailController),
        const SizedBox(height: 14),
        PasswordTff(
          controller: controller.passwordController,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 14),
        PasswordTff(
          controller: controller.confirmPasswordController,
          label: 'Confirmation mot de passe',
          icon: Icons.lock_reset_outlined,
          onSubmitted: (_) => controller.register(),
        ),
        const SizedBox(height: 22),
        Obx(
          () => AsyncButton(
            label: "S'inscrire",
            icon: Icons.person_add_alt_1_outlined,
            isLoading: controller.isLoading.value,
            // Le controller crée le compte, envoie l'email et sauvegarde Firestore.
            onPressed: controller.register,
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          // Ce lien revient au formulaire Login dans le même popup.
          onPressed: controller.showLoginForm,
          child: const Text('Déjà un compte ? Se connecter'),
        ),
      ],
    );
  }
}
