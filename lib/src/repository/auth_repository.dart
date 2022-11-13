import 'package:soical_user_authentication/soical_user_authentication.dart';
import 'package:user_authentication/src/models/auth_user.dart';
import 'package:user_authentication/src/models/user_response.dart';
import 'package:user_authentication/src/network_services/networking_services.dart';
import 'package:user_authentication/src/network_services/status_codes.dart';

import '../models/custom_response.dart';

class AuthRepository extends SoicalUserRepository {
  Future<UserResponse> signInUsingEmailAndPassword(
      {required String signinURL,
      required String email,
      required String password}) async {
    UserResponse userResponse = UserResponse();
    CustomResponse customResponse = await NetworkServices.instance
        .post(url: signinURL, body: {"email": email, "password": password});
    if ((customResponse.statusCode == StatusCode.success ||
            customResponse.statusCode == StatusCode.created) &&
        customResponse.data != null) {
      try {
        userResponse.user = AuthUser.fromMap(customResponse.data);
      } catch (_) {}
    } else {
      userResponse.error = customResponse.errorMessage;
    }
    return userResponse;
  }

  Future<void> logout() async {
    AuthUser.logout();
  }
}
