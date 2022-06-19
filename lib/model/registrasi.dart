class Registrasi {
  String? token;

  Registrasi({this.token});

  factory Registrasi.fromJson(Map<String, dynamic> obj) {
    return Registrasi(token: obj['token']['access_token']);
  }
}
