import 'package:user_authentication/user_authentication.dart';

class UserResponse {
  AuthUser? user;
  String? error;
  UserResponse({this.user, this.error});
}