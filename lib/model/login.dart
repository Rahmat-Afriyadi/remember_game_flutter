class Login {
  String? token;
  int? userID;
  String? userEmail;
  String? nama;
  int? score;

  Login({this.token, this.userID, this.userEmail, this.nama, this.score});

  factory Login.fromJson(Map<String, dynamic> obj) {
    return Login(
        token: obj['token']['access_token'],
        userID: obj['user']['id'],
        nama: obj['user']['name'],
        score: obj['user']['score'],
        userEmail: obj['user']['email']);
  }
}
