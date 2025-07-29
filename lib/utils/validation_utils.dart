
import 'package:email_validator/email_validator.dart';

class ValidationUtils {
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }
    if (!EmailValidator.validate(email)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return 'Name is required';
    }
    if (name.split(' ').length < 2) {
      return 'Please enter your full name';
    }
    return null;
  }

  static String? validatePhone(String? phone) {
    if (phone == null || phone.isEmpty) {
      return null; // Phone is optional
    }
    if (!RegExp(r'^[0-9]{10,15}$').hasMatch(phone)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  static String? validateAge(DateTime? birthDate) {
    if (birthDate == null) {
      return 'Birth date is required';
    }
    final age = DateTime.now().difference(birthDate).inDays ~/ 365;
    if (age < 13) {
      return 'You must be at least 13 years old';
    }
    return null;
  }
}