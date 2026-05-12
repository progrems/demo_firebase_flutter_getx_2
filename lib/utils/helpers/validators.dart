// Classe utilitaire pour centraliser les validations des formulaires.
// Les controllers l'utilisent avant d'appeler Firebase.
class Validators {
  static String? requiredField(String value, String fieldName) {
    // trim() évite qu'un champ rempli seulement avec des espaces soit accepté.
    if (value.trim().isEmpty) {
      return '$fieldName est obligatoire.';
    }
    return null;
  }

  static String? email(String value) {
    // Un email est d'abord un champ obligatoire.
    final requiredError = requiredField(value, 'Email');
    if (requiredError != null) {
      return requiredError;
    }

    // Vérification simple du format email.
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Email invalide.';
    }

    return null;
  }

  static String? password(String value) {
    // Le mot de passe est obligatoire.
    final requiredError = requiredField(value, 'Mot de passe');
    if (requiredError != null) {
      return requiredError;
    }

    // Firebase accepte souvent 6 caractères minimum pour email/password.
    if (value.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères.';
    }

    return null;
  }

  static String? confirmPassword(String password, String confirmation) {
    // La confirmation est obligatoire puis comparée au mot de passe.
    final requiredError = requiredField(
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
