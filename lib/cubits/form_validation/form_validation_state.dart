

part of 'form_validation_cubit.dart';

class FormValidationState extends Equatable {
  final Map<String, String?> errors;

  const FormValidationState({required this.errors});

  factory FormValidationState.initial() {
    return FormValidationState(errors: {
      'email': null,
      'password': null,
      'name': null,
      'phone': null,
      'birthDate': null,
    });
  }

  FormValidationState copyWith({Map<String, String?>? errors}) {
    return FormValidationState(errors: errors ?? this.errors);
  }

  @override
  List<Object?> get props => [errors];
}
