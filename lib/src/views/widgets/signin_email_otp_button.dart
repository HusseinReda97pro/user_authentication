import 'package:auth/provider/auth_provider.dart';
import 'package:flutter/material.dart';

class SignInEmailWithOTPButton extends StatefulWidget {
  final void Function()? onPressed;
  final Widget text;
  final TextEditingController emailController;
  final String signinURL;
  final ButtonStyle style;
  const SignInEmailWithOTPButton(
      {required this.signinURL,
      required this.emailController,
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
              email: widget.emailController.text,
            );
          },
      child: widget.text,
    );
  }
}
