// ignore: unnecessary_library_name
library not_found_page;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared_components/text/simple_text.dart';
import '../../../../shared_components/text/title_text.dart';

// binding
part '../../bindings/not_found_view_binding.dart';
// controller
part '../../controllers/not_found_view_controller.dart';

class NotFoundViewScreen extends GetView<NotFoundViewController> {
  const NotFoundViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TitleText('Page introuvable'),
            SizedBox(height: 8),
            SimpleText('La route demandée n’existe pas.'),
          ],
        ),
      ),
    );
  }
}
