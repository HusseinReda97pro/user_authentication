import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:user_authentication/src/models/otp_message.dart';
import 'package:user_authentication/user_authentication.dart';

class AuthProvider extends ChangeNotifier {
  String? error;
  bool isLoading = false;
  AuthUser? currentUser;
  AuthRepository authRepository;
  OTPMessage? otpMessage;
  // bool isLoading = false;

  setError(String? e) {
    error = e;
    notifyListeners();
  }

  AuthProvider({required this.authRepository});

  Future<bool> signInWithEmailAndPassword(
      {required String signinURL,
      required String email,
      required String password}) async {
    isLoading = true;
    error = null;
    notifyListeners();
    UserResponse userResponse =
        await authRepository.signInUsingEmailAndPassword(
            signinURL: signinURL, email: email, password: password);
    if (userResponse.user != null) {
      userResponse.user!.saveToSharedPreferences();
      currentUser = userResponse.user;
      isLoading = false;
      notifyListeners();
      return true;
    } else {
      if (userResponse.error != null) {
        error = userResponse.error;
        isLoading = false;
        notifyListeners();
      }
    }
    isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> signInWithEmailAndOTP(
      {required String signinURL, required String email}) async {
    isLoading = true;
    error = null;
    otpMessage = null;
    notifyListeners();
    otpMessage = await authRepository.signInUsingEmailAndOTP(
        signinURL: signinURL, email: email);
    if (otpMessage != null && otpMessage!.errors != null) {
      isLoading = false;
      error = otpMessage!.message;
      notifyListeners();
      return;
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> verifyOTP(
      {required String verifyURL, required String otp}) async {
    isLoading = true;
    error = null;
    notifyListeners();
    if (otpMessage == null || otpMessage!.tempKey == null) {
      isLoading = false;
      notifyListeners();
      error = 'حدث خطأ غير معروف';
      return;
    }
    UserResponse userResponse = await authRepository.verifyOTP(
        verifyURL: verifyURL, tempKey: otpMessage!.tempKey!, otp: otp);
    if (userResponse.error != null) {
      isLoading = false;
      error = userResponse.error;
      notifyListeners();
      return;
    } else {
      currentUser = userResponse.user;
      userResponse.user!.saveToSharedPreferences();
      error = null;
      otpMessage = null;
      isLoading = false;
      notifyListeners();
    }
  }

  autoLogin() async {
    isLoading = true;
    notifyListeners();
    currentUser = await AuthUser.getFromSharedPreferences();
    isLoading = false;
    notifyListeners();
  }

  @override
  logout() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      currentUser = null;
      authRepository.logout();
      isLoading = false;
      notifyListeners();
    } catch (_) {}
    isLoading = false;
    notifyListeners();
  }

  isUserLoggedin() {
    return currentUser != null;
  }

  static AuthProvider of(BuildContext context, {bool listen = false}) {
    if (listen) return context.watch<AuthProvider>();
    return context.read<AuthProvider>();
  }
}
