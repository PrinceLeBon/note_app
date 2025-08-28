import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import '../../../data/models/user.dart';
import '../../../data/repositories/user.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository userRepository;

  UserCubit({required this.userRepository}) : super(UserInitial());

  Future login(String email, String password) async {
    emit(Logging());
    try {
      final UserModel user = await userRepository.login(email, password);
      emit(Logged(user: user));
    } catch (e) {
      Logger().e("USER CUBIT || Error while login: $e");
      emit(LoggingFailed(error: "USER CUBIT || Error while login: $e"));
    }
  }

  Future logout() async {
    emit(LoggingOut());
    try {
      await userRepository.logout();
      emit(Logout());
    } catch (e) {
      Logger().e("USER CUBIT || Error while logout: $e");
      emit(LoggingFailed(error: "USER CUBIT || Error while logout: $e"));
    }
  }

  Future signup(String nom, String prenom, String mail, File photo,
      String password) async {
    emit(Signing());
    try {
      await userRepository.signup(nom, prenom, mail, photo, password);
      emit(Signin());
    } catch (e) {
      Logger().e("USER CUBIT || Error while signup: $e");
      emit(SigningFailed(error: "USER CUBIT || Error while signup: $e"));
    }
  }

  Future updateUser(UserModel updatedUser, File? newPhoto) async {
    emit(UpdatingUser());
    try {
      final UserModel user = await userRepository.updateUser(updatedUser, newPhoto);
      emit(UserUpdated(user: user));
    } catch (e) {
      Logger().e("USER CUBIT || Error while updating user: $e");
      emit(UpdatingUserFailed(error: "USER CUBIT || Error while updating user: $e"));
    }
  }

  UserModel? getCurrentUser() {
    try {
      return userRepository.getCurrentUser();
    } catch (e) {
      Logger().e("USER CUBIT || Error while getting current user: $e");
      return null;
    }
  }
}
