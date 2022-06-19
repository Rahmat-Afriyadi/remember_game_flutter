class Profile {
  String? nama;
  int? score;

  Profile({this.nama, this.score});

  factory Profile.fromJson(Map<String, dynamic> obj) {
    return Profile(
        nama: obj['name'],
        score: obj['score'],
    );
  }
}