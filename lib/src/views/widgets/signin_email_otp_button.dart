import 'package:flutter/material.dart';
import 'package:user_authentication/src/provider/auth_provider.dart';

class SignInEmailWithOTPButton extends StatefulWidget {
  final void Function()? onPressed;
  final Widget text;
  final String email;
  final String signinURL;
  final ButtonStyle style;
  const SignInEmailWithOTPButton(
      {required this.signinURL,
      required this.email,
      this.onPressed,
      required this.text,
      required this.style,
      Key? key})
      : super(key: key);

  @override
  State<SignInEmailWithOTPButton> createState() =>
      _SignInEmailWithOTPButtonState();
}

class _SignInEmailWithOTPButtonState extends State<SignInEmailWithOTPButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: widget.style,
      onPressed: widget.onPressed ??
          () async {
            AuthProvider.of(context).setError(null);
            await AuthProvider.of(context).signInWithEmailAndOTP(
              signinURL: widget.signinURL,
              email: widget.email,
            );
          },
      child: widget.text,
    );
  }
}
