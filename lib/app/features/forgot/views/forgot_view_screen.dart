import 'package:demo_firebase_flutter_getx_2/app/utils/mixins/app_mixins.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared_components/text/simple_text.dart';
import '../../../shared_components/text/title_text.dart';

// binding
part '../bindings/forgot_view_binding.dart';
// controller
part '../controllers/forgot_view_controller.dart';

class ForgotViewScreen extends GetView<ForgotViewController> {
  const ForgotViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TitleText('Mot de passe oublié'),
            SizedBox(height: 8),
            SimpleText(
              'La récupération est disponible dans le popup Connexion.',
            ),
          ],
        ),
      ),
    );
  }
}
