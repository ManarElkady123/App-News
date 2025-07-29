import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final List<UserModel> _registeredUsers = [];

  // Add logout method
  Future<void> logout() async {
    emit(AuthLoading());
    await secureStorage.delete(key: 'email');
    await secureStorage.delete(key: 'password');
    emit(AuthLoggedOut());
  }

  // Add register method
  Future<void> register(UserModel newUser) async {
    emit(AuthLoading());
    await Future.delayed(const Duration(seconds: 1));
    
    // Check if email exists
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString('registered_users');
    final List<UserModel> registeredUsers = usersJson != null 
        ? (jsonDecode(usersJson) as List)
            .map((e) => UserModel.fromJson(e))
            .toList()
        : [];
    
    if (registeredUsers.any((u) => u.email == newUser.email)) {
      emit(AuthError('Email already registered', 'email'));
      return;
    }
    
    registeredUsers.add(newUser);
    await prefs.setString('registered_users', jsonEncode(registeredUsers.map((u) => u.toJson()).toList()));
    
    emit(AuthRegistered(newUser));
  }

  // Password reset method
  Future<void> sendPasswordResetEmail(String email) async {
    emit(AuthLoading());
    await Future.delayed(const Duration(seconds: 1));
    
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString('registered_users');
    final List<UserModel> registeredUsers = usersJson != null 
        ? (jsonDecode(usersJson) as List)
            .map((e) => UserModel.fromJson(e))
            .toList()
        : [];
    
    if (!registeredUsers.any((u) => u.email == email)) {
      emit(AuthError('Email not registered', 'email'));
      return;
    }
    
    emit(AuthResetEmailSent(email));
  }

  // Credential saving method
  Future<void> saveUserCredentials(String email, String password) async {
    await secureStorage.write(key: 'email', value: email);
    await secureStorage.write(key: 'password', value: password);
  }

  // Login method
  Future<void> login(String email, String password, bool rememberMe) async {
    emit(AuthLoading());
    
    await Future.delayed(const Duration(seconds: 1));
    
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString('registered_users');
    final List<UserModel> registeredUsers = usersJson != null 
        ? (jsonDecode(usersJson) as List)
            .map((e) => UserModel.fromJson(e))
            .toList()
        : [];
    
    final user = registeredUsers.firstWhere(
      (u) => u.email == email && u.passwordH == password,
      orElse: () => UserModel.empty(),
    );
    
    if (user.email.isEmpty) {
      emit(AuthError('Invalid email or password', 'general'));
      return;
    }
    
    if (rememberMe) {
      await saveUserCredentials(email, password);
    }
    
    emit(AuthSuccess(user));
  }

  // Check auth status method
  Future<void> checkAuthStatus() async {
    final email = await secureStorage.read(key: 'email');
    final password = await secureStorage.read(key: 'password');
    
    if (email != null && password != null) {
      await login(email, password, true);
    }
  }
}