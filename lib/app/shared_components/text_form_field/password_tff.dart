import 'package:flutter/material.dart';

class PasswordTff extends StatelessWidget {
  const PasswordTff({
    required this.controller,
    this.label = 'Mot de passe',
    this.icon = Icons.lock_outline,
    this.textInputAction = TextInputAction.done,
    this.onSubmitted,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: true,
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
    );
  }
}
