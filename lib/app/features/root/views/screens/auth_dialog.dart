import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../login/views/screens/login_view_screen.dart';
import '../../../register/views/register_view_screen.dart';
import '../../controllers/root_controller.dart';

class AuthDialog extends GetView<RootController> {
  const AuthDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Obx(
            () => AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              // isLoginMode vient de RootController : true = Login, false = Register.
              // On reste dans le même popup, seul le formulaire affiché change.
              child: controller.isLoginMode.value
                  ? const LoginViewScreen(key: ValueKey('login-form'))
                  : const RegisterViewScreen(key: ValueKey('register-form')),
            ),
          ),
        ),
      ),
    );
  }
}
