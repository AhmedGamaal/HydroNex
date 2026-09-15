
class AuthValidators {
  AuthValidators._();

  static final RegExp _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) return 'Please enter your name';
    if (value.trim().length < 2) return 'Name is too short';
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Please enter your email';
    if (!_emailRegex.hasMatch(value.trim())) return 'Enter a valid email address';
    return null;
  }

  static String? password(String? value, {int minLength = 8}) {
    if (value == null || value.isEmpty) return 'Please enter your password';
    if (value.length < minLength) return 'Password must be at least $minLength characters';
    if (!value.contains(RegExp(r'[A-Za-z]'))) return 'Password must contain at least one letter';
    if (!value.contains(RegExp(r'[0-9]'))) return 'Password must contain at least one number';
    return null;
  }

  static String? confirmPassword(String? value, String original) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != original) return 'Passwords do not match';
    return null;
  }
}
