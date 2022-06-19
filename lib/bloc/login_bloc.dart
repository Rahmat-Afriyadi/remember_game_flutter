import 'dart:convert';
import 'package:remember_game/helpers/api.dart';
import 'package:remember_game/helpers/api_url.dart';
import 'package:remember_game/model/login.dart';
import 'package:remember_game/model/profile.dart';

class LoginBloc {
  static Future<Login> login({String? email, String? password}) async {
    String apiUrl = ApiUrl.login;
    var body = {"email": email, "password": password};
    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);
    return Login.fromJson(jsonObj);
  }

  static Future<Profile> me() async {
    String apiUrl = ApiUrl.me;
    var body = {"email": "email"};
    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);
    return Profile.fromJson(jsonObj);
  }
}
