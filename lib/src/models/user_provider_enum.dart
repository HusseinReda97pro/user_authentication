enum UserProvider { facebook, google, emailPassword }

extension CastText on UserProvider {
  String toText() {
    if (this == UserProvider.facebook) return 'facebook';
    if (this == UserProvider.google) return 'google';
    if (this == UserProvider.emailPassword) return 'emailPassword';
    return 'emailPassword';
  }
}

extension Cast on String {
  toUserProvider() {
    if (this == 'facebook') return UserProvider.facebook;
    if (this == 'google') return UserProvider.google;
    if (this == 'emailPassword') return UserProvider.emailPassword;
    return 'emailPassword';
  }
}
