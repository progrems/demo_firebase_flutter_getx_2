import 'package:flutter/material.dart';

class NameTff extends StatelessWidget {
  const NameTff({
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
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,
      decoration: const InputDecoration(
        labelText: 'Nom complet',
        prefixIcon: Icon(Icons.person_outline),
      ),
    );
  }
}
