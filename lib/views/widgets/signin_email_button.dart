import 'package:flutter/cupertino.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:user_authentication/provider/auth_provider.dart';

class SignInEmailButton extends StatefulWidget {
  final Function? onPressed;
  final TextEditingController? emailController;
  final TextEditingController? passwordController;
  final String? text;
  final bool mini;
  final double elevation;
  final String? signinURL;
  const SignInEmailButton(
      {this.signinURL,
      this.emailController,
      this.passwordController,
      this.onPressed,
      this.text,
      this.mini = false,
      this.elevation = 2.0,
      Key? key})
      : assert(onPressed != null ||
            (emailController != null &&
                passwordController != null &&
                signinURL != null)),
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
            await AuthProvider.of(context).signInWithEmailAndPassword(
                signinURL: widget.signinURL!,
                email: widget.emailController!.text,
                password: widget.passwordController!.text);
          },
    );
  }
}
