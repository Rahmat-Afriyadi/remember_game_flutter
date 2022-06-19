class MyData {
  List<Results>? results;

  MyData({this.results});

  MyData.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(new Results.fromJson(v));
      });
    }    
  }
}

class Results {
  String? tanggal;
  String? level;
  int? score;

  Results({this.tanggal, this.level, this.score});

  Results.fromJson(Map<String, dynamic> json) {
    tanggal = json['timestamp']['created_at'];
    level = json['level'];
    score = json['score'];
  }
}
