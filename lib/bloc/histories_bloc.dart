import 'dart:convert';
import 'package:remember_game/helpers/api.dart';
import 'package:remember_game/helpers/api_url.dart';
import 'package:remember_game/model/histories.dart';
import 'package:remember_game/model/history.dart';
import 'package:remember_game/model/rank.dart';

class HistoryBloc {
  static Future<MyData> getHistories() async {
    String apiUrl = ApiUrl.histories;
    var body = {"email": "email"};
    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);
    return MyData.fromJson(jsonObj);
    // List<dynamic> listProduk = (jsonObj as Map<String, dynamic>)['data'];
    // List<Produk> produks = [];
    // for (int i = 0; i < listProduk.length; i++) {
    //   produks.add(Produk.fromJson(listProduk[i]));
    // }
    // return produks;
  }

  static Future<History> addHistory(String level, int score) async {
    String apiUrl = ApiUrl.addHistories;
    var body = {"level": level, "score": score.toString() };
    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);

    return History.fromJson(jsonObj);
  }

  static Future<RankData> getRank() async {
    String apiUrl = ApiUrl.rankPage;
    var response = await Api().get(Uri.parse(apiUrl));
    var jsonObj = json.decode(response.body);

    return RankData.fromJson(jsonObj);
  }

}
