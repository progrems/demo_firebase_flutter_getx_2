import 'package:flutter/material.dart';

import '../../../shared_components/text/title_text.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: TitleText('Chargement...')));
  }
}
