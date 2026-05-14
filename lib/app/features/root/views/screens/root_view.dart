// ignore: unnecessary_library_name
library root_page;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared_components/buttons/async_button.dart';
import '../../controllers/root_controller.dart';

// binding
part '../../bindings/root_binding.dart';

class RootView extends GetView<RootController> {
  const RootView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 180,
          // Le premier écran reste simple : un seul bouton Compte.
          child: AsyncButton(
            label: 'Compte',
            // La view appelle seulement le controller, qui ouvre le popup.
            onPressed: controller.openAuthDialog,
          ),
        ),
      ),
    );
  }
}
