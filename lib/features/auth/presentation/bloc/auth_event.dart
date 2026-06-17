import 'package:equatable/equatable.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

final class CheckAuthStatus extends AuthEvent {
  const CheckAuthStatus();
}

final class SignInRequested extends AuthEvent {
  const SignInRequested();
}

final class SignOutRequested extends AuthEvent {
  const SignOutRequested();
}
