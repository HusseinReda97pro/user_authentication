class OTPMessage {
  final String message;
  final String? tempKey;
  final Map<String, dynamic>? errors;
  OTPMessage({required this.message, this.tempKey, this.errors});

  factory OTPMessage.fromMap(data) => OTPMessage(
      message: data['message'],
      tempKey: data['temp_key'],
      errors: data['errors']);
  toMap() => {'message': message, 'temp_key': tempKey, 'errors': errors};
}
