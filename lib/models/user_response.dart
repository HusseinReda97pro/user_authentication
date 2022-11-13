import 'package:user_authentication/models/auth_user.dart';

class UserResponse {
  AuthUser? user;
  String? error;
  UserResponse({this.user, this.error});
}
