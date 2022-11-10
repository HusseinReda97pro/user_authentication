import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:user_authentication/provider/auth_provider.dart';

class SigninFacebookButton extends StatefulWidget {
  final String? text;
  final Function? onPressed;
  const SigninFacebookButton({this.text, this.onPressed, Key? key})
      : super(key: key);

  @override
  State<SigninFacebookButton> createState() => _SigninFacebookButtonState();
}

class _SigninFacebookButtonState extends State<SigninFacebookButton> {
  @override
  Widget build(BuildContext context) {
    return SignInButton(
      Buttons.FacebookNew,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
      text: widget.text,
      onPressed: widget.onPressed ??
          () async {
            AuthProvider.of(context).signInWithFacebook();
          },
    );
  }
}
