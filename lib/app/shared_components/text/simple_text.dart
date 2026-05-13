import 'package:flutter/material.dart';

import '../../config/themes/app_style.dart';

class SimpleText extends StatelessWidget {
  const SimpleText(this.text, {super.key, this.textAlign, this.muted = false});

  final String text;
  final TextAlign? textAlign;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: muted ? AppStyle.muted : AppStyle.body,
    );
  }
}
