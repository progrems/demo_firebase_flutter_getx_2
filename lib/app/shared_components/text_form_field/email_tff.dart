import 'package:flutter/material.dart';

class EmailTff extends StatelessWidget {
  const EmailTff({
    required this.controller,
    this.textInputAction = TextInputAction.next,
    this.onSubmitted,
    super.key,
  });

  final TextEditingController controller;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,
      decoration: const InputDecoration(
        labelText: 'Email',
        prefixIcon: Icon(Icons.email_outlined),
      ),
    );
  }
}
