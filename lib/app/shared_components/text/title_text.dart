import 'package:flutter/material.dart';

import '../../config/themes/app_style.dart';

class TitleText extends StatelessWidget {
  const TitleText(this.text, {super.key, this.textAlign});

  final String text;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(text, textAlign: textAlign, style: AppStyle.dialogTitle);
  }
}
