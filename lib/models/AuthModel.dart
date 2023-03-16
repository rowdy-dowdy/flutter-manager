import 'package:manager/models/UserModel.dart';

enum AuthState {
  initial,
  login,
  notLogin
}

class AuthModel {
  final AuthState authState;
  final UserModel? user;
  
  AuthModel({
    required this.user,
    required this.authState,
  });

  const AuthModel.unknown()
    : authState = AuthState.initial,
      user = null;

  AuthModel changeState (AuthState authState) {
    return AuthModel(user: user, authState: authState);
  }
}
