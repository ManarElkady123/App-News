

part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthLoggedOut extends AuthState {}

class AuthSuccess extends AuthState {
  final UserModel user;
  const AuthSuccess(this.user);
  
  @override
  List<Object> get props => [user];
}

class AuthRegistered extends AuthState {
  final UserModel user;
  const AuthRegistered(this.user);
  
  @override
  List<Object> get props => [user];
}

// Add this state for password reset
class AuthResetEmailSent extends AuthState {
  final String email;
  const AuthResetEmailSent(this.email);
  
  @override
  List<Object> get props => [email];
}

class AuthError extends AuthState {
  final String message;
  final String field;
  const AuthError(this.message, this.field);
  
  @override
  List<Object> get props => [message, field];
}