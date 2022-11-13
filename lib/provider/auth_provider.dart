import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:soical_user_authentication/soical_user_authentication.dart';
import 'package:user_authentication/models/auth_user.dart';
import 'package:user_authentication/models/user_response.dart';
import 'package:user_authentication/repository/auth_repository.dart';

class AuthProvider extends SoicalUserProvider {
  AuthUser? currentUser;
  AuthRepository authRepository;
  // bool isLoading = false;

  setError(String? e) {
    error = e;
    notifyListeners();
  }

  AuthProvider({required this.authRepository})
      : super(soicalUserRepository: SoicalUserRepository());

  @override
  Future<bool> signInWithGoogle() async {
    bool signedIn = await super.signInWithGoogle();
    if (signedIn && super.currentSoicalUser != null) {
      currentUser = AuthUser(
        id: super.currentSoicalUser!.id,
        name: super.currentSoicalUser!.name,
        email: super.currentSoicalUser!.email,
        provider: super.currentSoicalUser!.provider,
        soicalId: super.currentSoicalUser!.id,
        imageURL: super.currentSoicalUser!.imageURL,
      );
      currentUser!.saveToSharedPreferences();
    }
    return signedIn;
  }

  @override
  Future<bool> signInWithFacebook() async {
    bool signedIn = await super.signInWithFacebook();
    if (signedIn && super.currentSoicalUser != null) {
      currentUser = AuthUser(
        id: super.currentSoicalUser!.id,
        name: super.currentSoicalUser!.name,
        email: super.currentSoicalUser!.email,
        provider: super.currentSoicalUser!.provider,
        soicalId: super.currentSoicalUser!.id,
        imageURL: super.currentSoicalUser!.imageURL,
      );
      currentUser!.saveToSharedPreferences();
    }
    return signedIn;
  }

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

  static AuthProvider of(BuildContext context, {bool listen = false}) {
    if (listen) return context.watch<AuthProvider>();
    return context.read<AuthProvider>();
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
      if (currentUser != null &&
          currentUser!.provider == UserProvider.facebook) {
        await soicalUserRepository.logoutFromFacebook();
      }
      if (currentUser != null && currentUser!.provider == UserProvider.google) {
        await soicalUserRepository.logoutFromGoogle();
      }
      currentSoicalUser = null;
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
}
