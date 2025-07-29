



import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../utils/validation_utils.dart';

part 'form_validation_state.dart';

class FormValidationCubit extends Cubit<FormValidationState> {
  FormValidationCubit() : super(FormValidationState.initial());

  void validateField({required String field, required String? value, DateTime? birthDate}) {
    final newErrors = Map<String, String?>.from(state.errors);

    switch (field) {
      case 'email':
        newErrors['email'] = ValidationUtils.validateEmail(value);
        break;
      case 'password':
        newErrors['password'] = ValidationUtils.validatePassword(value);
        break;
      case 'name':
        newErrors['name'] = ValidationUtils.validateName(value);
        break;
      case 'phone':
        newErrors['phone'] = ValidationUtils.validatePhone(value);
        break;
      case 'birthDate':
        newErrors['birthDate'] = ValidationUtils.validateAge(birthDate);
        break;
    }

    emit(state.copyWith(errors: newErrors));
  }

  void resetValidation() {
    emit(FormValidationState.initial());
  }
}
