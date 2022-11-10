import 'package:soical_user_authentication/soical_user_authentication.dart';
import 'package:user_authentication/models/auth_user.dart';
import 'package:user_authentication/network_services/networking_services.dart';
import 'package:user_authentication/network_services/status_codes.dart';

import '../models/custom_response.dart';

class AuthRepository extends SoicalUserRepository {
  Future<AuthUser?> signInUsingEmailAndPassword(
      {required String signinURL,
      required String email,
      required String password}) async {
    AuthUser? user;
    CustomResponse customResponse = await NetworkServices.instance
        .post(url: signinURL, body: {"email": email, "password": password});
    if ((customResponse.statusCode == StatusCode.success ||
            customResponse.statusCode == StatusCode.created) &&
        customResponse.data != null) {
      try {
        user = AuthUser.fromMap(customResponse.data);
      } catch (_) {}
    }
    return user;
  }

  Future<void> logout() async {
    AuthUser.logout();
  }
}
