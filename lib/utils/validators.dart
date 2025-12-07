class Validators {
  static String? notEmpty(String? value, {String fieldName = 'Field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? email(String? value) {
    final baseMessage = notEmpty(value, fieldName: 'Email');
    if (baseMessage != null) return baseMessage;
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value!.trim())) {
      return 'Enter a valid email';
    }
    return null;
  }

  static String? password(String? value) {
    if ((value ?? '').length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? phone(String? value) {
    final baseMessage = notEmpty(value, fieldName: 'Phone');
    if (baseMessage != null) return baseMessage;
    final phoneRegex = RegExp(r'^[0-9]{10}$');
    if (!phoneRegex.hasMatch(value!.trim())) {
      return 'Enter a 10 digit number';
    }
    return null;
  }
}

