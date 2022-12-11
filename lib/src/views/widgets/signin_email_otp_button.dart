import 'package:flutter/material.dart';
import 'package:user_authentication/src/provider/auth_provider.dart';

class SignInEmailWithOTPButton extends StatefulWidget {
  final void Function()? onPressed;
  final Widget text;
  final TextEditingController emailController;
  final String signinURL;
  final ButtonStyle style;
  final Function onSuccess;
  const SignInEmailWithOTPButton(
      {required this.signinURL,
      required this.emailController,
      this.onPressed,
      required this.text,
      required this.style,
      required this.onSuccess,
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
            if (!mounted) return;
            if (AuthProvider.of(context).error != null &&
                AuthProvider.of(context).otpMessage != null) {
              widget.onSuccess();
            }
          },
      child: widget.text,
    );
  }
}
