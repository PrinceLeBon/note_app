part of 'user_cubit.dart';

@immutable
abstract class UserState {
  const UserState();
}

class UserInitial extends UserState {}

class Logging extends UserState {}

class LoggingFailed extends UserState {
  final String error;

  const LoggingFailed({required this.error});
}

class Logged extends UserState {
  final UserModel user;

  const Logged({required this.user});
}

class Signing extends UserState {}

class SigningFailed extends UserState {
  final String error;

  const SigningFailed({required this.error});
}

class Signin extends UserState {}
