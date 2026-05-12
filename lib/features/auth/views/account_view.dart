import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared_components/widgets/custom_button.dart';
import '../controllers/auth_controller.dart';

class AccountView extends StatelessWidget {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    // La vue récupère le controller GetX, puis lui délègue l'ouverture
    // du popup. Ainsi, la logique ne reste pas dans le widget.
    final authController = Get.find<AuthController>();

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 180,
          child: CustomButton(
            label: 'Compte',

            // Premier geste utilisateur : ouvrir le popup Connexion/Inscription.
            onPressed: authController.openAuthDialog,
          ),
        ),
      ),
    );
  }
}
