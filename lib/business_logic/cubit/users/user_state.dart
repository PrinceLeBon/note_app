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

class LoggingOut extends UserState {}

class LoggingOutFailed extends UserState {
  final String error;

  const LoggingOutFailed({required this.error});
}

class Logout extends UserState {}

class Signing extends UserState {}

class SigningFailed extends UserState {
  final String error;

  const SigningFailed({required this.error});
}

class Signin extends UserState {}

class UpdatingUser extends UserState {}

class UserUpdated extends UserState {
  final UserModel user;

  const UserUpdated({required this.user});
}

class UpdatingUserFailed extends UserState {
  final String error;

  const UpdatingUserFailed({required this.error});
}
