class RankData {
  List<RankResults>? results;

  RankData({this.results});

  RankData.fromJson(List<dynamic> json) {
    if (json != null) {
      results = <RankResults>[];
      json.forEach((v) {
        results!.add(new RankResults.fromJson(v));
      });
    }    
  }
}

class RankResults {
  String? nama;
  int? score;

  RankResults({this.nama, this.score});

  RankResults.fromJson(Map<String, dynamic> json) {
    nama = json['name'];
    score = json['score'];
  }
}
