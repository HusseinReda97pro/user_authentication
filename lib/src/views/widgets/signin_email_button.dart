import 'package:flutter/cupertino.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:user_authentication/src/provider/auth_provider.dart';

class SignInEmailButton extends StatefulWidget {
  final Function? onPressed;
  final String? email;
  final String? password;
  final String? text;
  final String? Function(String)? validateEmail;
  final String? Function(String)? validatePassword;
  final bool mini;
  final double elevation;
  final String? signinURL;
  const SignInEmailButton(
      {this.signinURL,
      this.email,
      this.password,
      this.onPressed,
      this.text,
      this.validateEmail,
      this.validatePassword,
      this.mini = false,
      this.elevation = 2.0,
      Key? key})
      : assert(onPressed != null ||
            (email != null && password != null && signinURL != null)),
        super(key: key);

  @override
  State<SignInEmailButton> createState() => _SignInEmailButtonState();
}

class _SignInEmailButtonState extends State<SignInEmailButton> {
  @override
  Widget build(BuildContext context) {
    return SignInButton(
      Buttons.Email,
      mini: widget.mini,
      elevation: widget.elevation,
      text: widget.text,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
        // side: BorderSide(color: Theme.of(context).primaryColor),
      ),
      // text: "Sign up with Google",
      onPressed: widget.onPressed ??
          () async {
            AuthProvider.of(context).setError(null);
            if (widget.email!.isEmpty || widget.password!.isEmpty) {
              AuthProvider.of(context).setError('Missing Email or Password');
              return;
            }
            if (widget.validateEmail != null) {
              String? error = widget.validateEmail!(widget.email!);
              if (error != null) {
                AuthProvider.of(context).setError(error);
                return;
              }
            }
            if (widget.validatePassword != null) {
              String? error = widget.validatePassword!(widget.password!);
              if (error != null) {
                AuthProvider.of(context).setError(error);
                return;
              }
            }
            await AuthProvider.of(context).signInWithEmailAndPassword(
              signinURL: widget.signinURL!,
              email: widget.email!,
              password: widget.password!,
            );
          },
    );
  }
}
