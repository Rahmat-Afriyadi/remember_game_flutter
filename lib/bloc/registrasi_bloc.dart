import 'dart:convert';
import 'package:remember_game/helpers/api.dart';
import 'package:remember_game/helpers/api_url.dart';
import 'package:remember_game/model/registrasi.dart';

class RegistrasiBloc {
  static Future<Registrasi> registrasi(
      {String? nama, String? email, String? password}) async {
    String apiUrl = ApiUrl.registrasi;

    var body = {"name": nama, "email": email, "password": password};

    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);
    print("ini jsonya ${jsonObj}");
    return Registrasi.fromJson(jsonObj);
  }
}
