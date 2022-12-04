import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:soical_user_authentication/soical_user_authentication.dart';

class AuthUser {
  String id;
  String name;
  String email;
  UserProvider provider;
  String? soicalId;
  String? imageURL;
  String? jsonWebToken;
  DateTime? emailVerifiedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  AuthUser({
    required this.id,
    required this.name,
    required this.email,
    required this.provider,
    this.soicalId,
    this.imageURL,
    this.jsonWebToken,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory AuthUser.fromJson(data) => fromMap(json.decode(data));

  @override
  String toString() {
    return 'id:$id, username: $name, email: $email, soicalId :$soicalId, token: $jsonWebToken, ImageUrl: $imageURL';
  }

  Map<String, dynamic> get toMap {
    return {
      "id": id,
      "name": name,
      "email": email,
      "soical_id": soicalId,
      "token": jsonWebToken,
      "image_url": imageURL,
      "provider": provider,
      "email_verified_at": emailVerifiedAt,
      "created_at": createdAt,
      "updated_at": updatedAt,
    };
  }

  toJson() => json.encode(toMap);

  saveToSharedPreferences() async {
    var pref = await SharedPreferences.getInstance();
    pref.setString('name', name);
    pref.setString('email', email);
    // if (id != null) {
    pref.setString('id', id);
    // }
    if (jsonWebToken != null) {
      pref.setString('jwt', jsonWebToken!);
    }
    if (soicalId != null) {
      pref.setString('soical_id', soicalId!);
    }
    pref.setString('provider', provider.toText());

    if (imageURL != null) {
      pref.setString('image_url', imageURL!);
    }
  }

  static Future<AuthUser?> getFromSharedPreferences() async {
    var pref = await SharedPreferences.getInstance();
    AuthUser? user;
    String? id = pref.getString('id');
    String? name = pref.getString('name');
    String? email = pref.getString('email');
    String? imageURL = pref.getString('image_url');
    String? soicalId = pref.getString('soical_id');
    String? jsonWebToken = pref.getString('token');
    String? provider = pref.getString('provider');
    try {
      if (id != null && email != null && name != null && provider != null) {
        user = AuthUser(
          id: id,
          name: name,
          email: email,
          imageURL: imageURL,
          jsonWebToken: jsonWebToken,
          soicalId: soicalId,
          provider: provider.toUserProvider(),
        );
      }
    } catch (_) {}
    return user;
  }

  static logout() async {
    var pref = await SharedPreferences.getInstance();
    pref.remove('id');
    pref.remove('name');
    pref.remove('email');
    pref.remove('image_url');
    pref.remove('soical_id');
    pref.remove('token');
    pref.remove('provider');
  }

  static AuthUser fromMap(Map<String, dynamic> data) {
    return AuthUser(
        id: data['id'],
        name: data['name'],
        email: data['email'],
        soicalId: data['soical_id'],
        jsonWebToken: data['token'],
        imageURL: data['image_url'],
        provider: UserProvider.emailPassword,
        emailVerifiedAt: data['email_verified_at'],
        createdAt: data['created_at'],
        updatedAt: data['updated_at']);
  }

  // factory User.fromFacebook(data) => FacebookUser.fromMap(data);
  // factory User.fromGoogle(googleSignInAccount) =>
  //     GoogleUser.fromMap(googleSignInAccount);
}
