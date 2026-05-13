mixin ValidationInputMixin {
  String? validateRequired(String value, String fieldName) {
    if (value.trim().isEmpty) {
      return '$fieldName est obligatoire.';
    }
    return null;
  }

  String? validateEmail(String value) {
    final requiredError = validateRequired(value, 'Email');
    if (requiredError != null) {
      return requiredError;
    }

    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Email invalide.';
    }

    return null;
  }

  String? validatePassword(String value) {
    final requiredError = validateRequired(value, 'Mot de passe');
    if (requiredError != null) {
      return requiredError;
    }

    if (value.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères.';
    }

    return null;
  }

  String? validateConfirmPassword(String password, String confirmation) {
    final requiredError = validateRequired(
      confirmation,
      'Confirmation du mot de passe',
    );
    if (requiredError != null) {
      return requiredError;
    }

    if (password != confirmation) {
      return 'La confirmation doit être identique au mot de passe.';
    }

    return null;
  }
}
