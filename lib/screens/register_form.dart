import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lab16_1/cubits/auth_cubit.dart';
import 'package:flutter_lab16_1/cubits/form_validation/form_validation_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user_model.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  DateTime? _birthDate;
  bool _rememberMe = false;

  Future<void> _saveRememberMePreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('remember_me', value);
  }

  void _selectBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _birthDate = picked);
      context.read<FormValidationCubit>().validateField(
            field: 'birthDate',
            value: null,
            birthDate: _birthDate,
          );
    }
  }

  void _submitForm() {
    // Validate all fields
    context.read<FormValidationCubit>().validateField(
          field: 'email',
          value: _emailController.text,
        );
    context.read<FormValidationCubit>().validateField(
          field: 'password',
          value: _passwordController.text,
        );
    context.read<FormValidationCubit>().validateField(
          field: 'name',
          value: _nameController.text,
        );
    context.read<FormValidationCubit>().validateField(
          field: 'phone',
          value: _phoneController.text,
        );
    context.read<FormValidationCubit>().validateField(
          field: 'birthDate',
          value: null,
          birthDate: _birthDate,
        );

    // Check if form is valid
    final formState = context.read<FormValidationCubit>().state;
    final hasErrors = formState.errors.values.any((error) => error != null);

    if (!hasErrors) {
      final nameParts = _nameController.text.split(' ');
      final firstName = nameParts.first;
      final lastName =
          nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

      final newUser = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        firstName: firstName,
        lastName: lastName,
        email: _emailController.text,
        passwordH: _passwordController.text, // In real app, hash this
        phoneNumber: _phoneController.text,
        dateOfBirth: _birthDate,
        profileImage: null,
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );

      context.read<AuthCubit>().register(newUser);
    }
     if (!hasErrors) {
    final nameParts = _nameController.text.split(' ');
    final firstName = nameParts.first;
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
    
    final newUser = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      firstName: firstName,
      lastName: lastName,
      email: _emailController.text,
      passwordH: _passwordController.text,
      phoneNumber: _phoneController.text,
      dateOfBirth: _birthDate,
      profileImage: null,
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
    );

    context.read<AuthCubit>().register(newUser);
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthRegistered) {
            // if (_rememberMe) {
            //   context.read<AuthCubit>().saveUserCredentials(
            //     state.user.email,
            //     state.user.passwordH,
            //   );
            // }

            if (_rememberMe) {
              context.read<AuthCubit>().saveUserCredentials(
                    state.user.email,
                    state.user.passwordH,
                  );
            }
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          } else if (state is AuthError && state.field == 'email') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: ListView(
              children: [
                BlocBuilder<FormValidationCubit, FormValidationState>(
                  builder: (context, formState) {
                    return TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        errorText: formState.errors['email'],
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        context.read<FormValidationCubit>().validateField(
                              field: 'email',
                              value: value,
                            );
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),
                BlocBuilder<FormValidationCubit, FormValidationState>(
                  builder: (context, formState) {
                    return TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        errorText: formState.errors['password'],
                      ),
                      onChanged: (value) {
                        context.read<FormValidationCubit>().validateField(
                              field: 'password',
                              value: value,
                            );
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),
                BlocBuilder<FormValidationCubit, FormValidationState>(
                  builder: (context, formState) {
                    return TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        errorText: formState.errors['name'],
                      ),
                      onChanged: (value) {
                        context.read<FormValidationCubit>().validateField(
                              field: 'name',
                              value: value,
                            );
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),
                BlocBuilder<FormValidationCubit, FormValidationState>(
                  builder: (context, formState) {
                    return TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: 'Phone (optional)',
                        prefixIcon: const Icon(Icons.phone),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        errorText: formState.errors['phone'],
                      ),
                      keyboardType: TextInputType.phone,
                      onChanged: (value) {
                        context.read<FormValidationCubit>().validateField(
                              field: 'phone',
                              value: value,
                            );
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),
                const Text('Birth Date'),
                const SizedBox(height: 8),
                InkWell(
                  onTap: _selectBirthDate,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      errorText: context
                          .watch<FormValidationCubit>()
                          .state
                          .errors['birthDate'],
                    ),
                    child: Text(
                      _birthDate != null
                          ? "${_birthDate!.toLocal()}".split(' ')[0]
                          : 'Select your birth date',
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (value) async {
                        setState(() {
                          _rememberMe = value!;
                        });
                        await _saveRememberMePreference(value!);
                      },
                    ),
                    const Text('Remember me'),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: state is AuthLoading ? null : _submitForm,
                    child: state is AuthLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Create Account'),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: const Text('Already have an account? Login'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
