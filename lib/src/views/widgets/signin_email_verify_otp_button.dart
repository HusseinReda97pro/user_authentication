import 'package:flutter/material.dart';
import 'package:user_authentication/src/provider/auth_provider.dart';

class VerifyOTPButton extends StatefulWidget {
  final void Function()? onPressed;
  final Widget text;
  final TextEditingController otpController;
  final String verifyURL;
  final ButtonStyle style;
  final Function onSuccess;
  final bool disabled;

  const VerifyOTPButton(
      {required this.verifyURL,
      required this.otpController,
      this.onPressed,
      required this.text,
      required this.style,
      required this.onSuccess,
      this.disabled = false,
      Key? key})
      : super(key: key);

  @override
  State<VerifyOTPButton> createState() => _VerifyOTPButtonState();
}

class _VerifyOTPButtonState extends State<VerifyOTPButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: widget.style,
      onPressed: widget.disabled
          ? null
          : widget.onPressed ??
              (AuthProvider.of(context).otpMessage != null &&
                      AuthProvider.of(context).otpMessage!.tempKey != null
                  ? () async {
                      AuthProvider.of(context).setError(null);
                      await AuthProvider.of(context).verifyOTP(
                        verifyURL: widget.verifyURL,
                        otp: widget.otpController.text,
                      );
                      if (!mounted) return;
                      if (AuthProvider.of(context).isUserLoggedin()) {
                        widget.onSuccess();
                      }
                    }
                  : null),
      child: widget.text,
    );
  }
}
