import 'package:flutter/material.dart';

// Bouton réutilisable. Il gère aussi l'état de chargement avec un spinner.
class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.fullWidth = true,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    // Si isLoading est true, on remplace le texte par un loader.
    final child = isLoading
        ? const SizedBox.square(
            dimension: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );

    final button = ElevatedButton(
      // Pendant le chargement, le bouton est désactivé.
      onPressed: isLoading ? null : onPressed,
      child: child,
    );

    // fullWidth permet d'avoir soit un bouton pleine largeur,
    // soit un bouton qui prend seulement la place nécessaire.
    if (!fullWidth) {
      return button;
    }

    return SizedBox(width: double.infinity, child: button);
  }
}
