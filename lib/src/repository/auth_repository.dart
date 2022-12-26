import 'package:soical_user_authentication/soical_user_authentication.dart';
import 'package:user_authentication/src/models/auth_user.dart';
import 'package:user_authentication/src/models/otp_message.dart';
import 'package:user_authentication/src/models/user_response.dart';
import 'package:user_authentication/src/network_services/networking_services.dart';
import 'package:user_authentication/src/network_services/status_codes.dart';

import '../helper/validation.dart';
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

  Future<OTPMessage> signInUsingEmailAndOTP(
      {required String signinURL, required String email}) async {
    if (email.isEmpty) {
      return OTPMessage(message: 'حقل البريد الالكتروني مطلوب', errors: {
        "email": ["حقل البريد الالكتروني مطلوب"]
      });
    }
    if (!Validation.validateEmaile(email: email)) {
      return OTPMessage(message: 'حقل البريد الالكتروني غير صالح', errors: {
        "email": ["حقل البريد الالكتروني غير صالح"]
      });
    }
    CustomResponse customResponse = await NetworkServices.instance
        .post(url: signinURL, body: {"email": email});
    if ((customResponse.statusCode == StatusCode.success ||
            customResponse.statusCode == StatusCode.created) &&
        customResponse.data != null) {
      return OTPMessage.fromMap(customResponse.data);
    } else {
      // Logger().i("customResponse.data", customResponse.data);

      return OTPMessage(message: 'حدث خطأ غير معروف', errors: {});
    }
  }

  Future<UserResponse> verifyOTP({
    required String verifyURL,
    required String otp,
    required String tempKey,
    Map? extraBodyData,
  }) async {
    UserResponse userResponse = UserResponse();

    Map body = {"otp": otp, 'temp_key': tempKey};
    if (extraBodyData != null) body.addAll(extraBodyData);
    CustomResponse customResponse =
        await NetworkServices.instance.post(url: verifyURL, body: body);
    if ((customResponse.statusCode == StatusCode.success ||
            customResponse.statusCode == StatusCode.created) &&
        customResponse.data != null) {
      try {
        customResponse.data['member']['token'] = customResponse.data['token'];
        userResponse.user = AuthUser.fromMap(customResponse.data['member']);
      } catch (e, s) {
        print(e);
        print(s);
        userResponse.error = 'حدث خطأ غير معروف';
      }
    } else {
      userResponse.error = customResponse.errorMessage;
    }
    return userResponse;
  }

  Future<void> logout() async {
    AuthUser.logout();
  }
}
