// lib/screens/reset_password_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lab16_1/cubits/auth_cubit.dart';
import 'package:flutter_lab16_1/cubits/form_validation/form_validation_cubit.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthResetEmailSent) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Reset link sent to ${state.email}'),
              ),
            );
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Enter your email address to receive a password reset link',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
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
                const SizedBox(height: 24),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      // Validate email first
                      context.read<FormValidationCubit>().validateField(
                        field: 'email',
                        value: _emailController.text,
                      );
                      
                      final formState = context.read<FormValidationCubit>().state;
                      if (formState.errors['email'] == null) {
                        context.read<AuthCubit>().sendPasswordResetEmail(
                          _emailController.text,
                        );
                      }
                    },
                    child: state is AuthLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Send Reset Link'),
                  ),
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
    super.dispose();
  }
}